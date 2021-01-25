class ExecuteSearch
  def self.call(params, adapter = :net_http, stubs = nil)
    instance = new(params, adapter, stubs)
    instance.execute
  end

  attr_reader :search_type, :limit, :cursor, :expires_at, :query_params, :coinbase_client, :sort

  def initialize(params, adapter, stubs)
    params = params.with_indifferent_access
    @search_type = params.delete(:search_type).to_s
    @limit = params.delete(:limit) || 50
    @cursor = params[:cursor] && CGI.unescape(params.delete(:cursor))
    @expires_at = params.delete :expires_at
    @sort = params.delete :sort
    @query_params = params
    @coinbase_client = CoinbaseClient.new conn(adapter, stubs)
    query_params[:interval] = query_params[:interval]&.to_i
  end

  def execute
    return search_result_hash(existing_search) if existing_search.present?

    search = new_search

    return { errors: search.errors } unless search.valid?

    populate_result(search)
    search_result_hash(search)
  end

  private

  def new_search
    Search.new search_type: search_type,
               query_params: query_params,
               expires_at: expires_at,
               limit: limit,
               cursor: cursor,
               sort: sort
  end

  def search_result_hash(search)
    Rails.cache.fetch(cache_key(search)) do
      return nil unless search.result.present?

      {
        data: search.result,
        cursor: calculate_cursor(search)
      }
    end
  end

  def conn(adapter, stubs)
    Faraday.new(connection_opts) do |builder|
      builder.use :http_cache, store: Rails.cache, logger: Rails.logger, serializer: Marshal

      if adapter == :test
        builder.adapter(:test, stubs)
      else
        builder.adapter(adapter)
      end
    end
  end

  COINBASE_PRO_API_ROOT_URL = 'https://api.pro.coinbase.com'.freeze

  def connection_opts
    {
      url: COINBASE_PRO_API_ROOT_URL,
      headers: { 'Content-Type' => 'application/json' }
    }
  end

  def existing_search
    return @existing_search if @existing_search

    s = Search
        .by_type(search_type)
        .by_query(query_params)
        .by_limit_and_cursor(limit, cursor)
        .by_sort(sort)
        .first

    @existing_search = s

    return @existing_search unless @existing_search.present? && @existing_search.expires_at <= Time.now

    populate_result(s)
    @existing_search
  end

  def cache_key(search)
    params = query_params.each_with_object([]) do |kvp, acc|
      acc.push(kvp.join(':'))
    end.join('-')

    key = Digest::SHA1.hexdigest([search_type, params, sort, limit, cursor, search.expires_at].join(';'))

    [search_type, key].join('/')
  end

  def populate_result(search)
    case search.search_type
    when Search::SEARCH_TYPES[:currencies]
      populate_currencies
      populate_currencies_result(search)
    when Search::SEARCH_TYPES[:pairs]
      populate_pairs
      populate_pairs_result(search)
    when Search::SEARCH_TYPES[:rates]
      populate_rates
      populate_rates_result(search)
    else
      raise "#{search.search_type} search not yet implemented"
    end
  end

  # only populates first 300 rates
  def populate_rates
    coinbase_client.rates(query_params[:symbols], rates_start, rates_end, query_params[:interval]).each do |rates_response|
      rates_response[:pair] = find_or_create_pair(rates_response.delete(:symbols))
      Coinbase::Rate.find_or_create_by time: rates_response[:time], interval: rates_response[:interval] do |rt|
        rt.assign_attributes(rates_response)
      end
    end
  end

  def rates_start
    return unless cursor.present?

    direction, unix = Base64.decode64(cursor).split('__')
    return Time.at(unix.to_i).iso8601 if direction == 'after'

    hours = ((300 * (query_params[:interval] || 60)) / 60) / 60
    (Time.at(unix.to_i) - hours.hours).iso8601
  end

  def rates_end
    return unless cursor.present?

    direction, unix = Base64.decode64(cursor).split('__')
    return Time.at(unix.to_i).iso8601 if direction == 'before'

    hours = ((300 * (query_params[:interval] || 60)) / 60) / 60
    (Time.at(unix.to_i) + hours.hours).iso8601
  end

  def find_or_create_pair(symbols)
    pair = Coinbase::Pair.find_by symbols: symbols
    return pair if pair.present?

    pair_response = coinbase_client.pair(symbols)
    return unless pair_response.present?

    pair_response[:base_currency] = find_or_create_currency(pair_response[:base_currency])
    pair_response[:quote_currency] = find_or_create_currency(pair_response[:quote_currency])

    Coinbase::Pair.create pair_response
  end

  def populate_rates_result(search)
    search.result = RateBlueprint.render_as_hash rates.limit(limit).paginated(cursor)
    search.save
  end

  def rates
    @rates ||= Coinbase::Rate
               .order(sort || :time)
               .includes(:pair)
               .by_symbols(query_params[:symbols])
               .by_interval(query_params[:interval] || 60)
  end

  def populate_pairs
    existing_pair_names = Coinbase::Pair.all.map(&:symbols)

    pairs_to_persist = coinbase_client.pairs.reject do |c|
      existing_pair_names.include?(c[:symbols])
    end

    pairs_to_persist.each do |p|
      p[:base_currency] = find_or_create_currency(p[:base_currency])
      p[:quote_currency] = find_or_create_currency(p[:quote_currency])
      Coinbase::Pair.create p
    end
  end

  def find_or_create_currency(symbol)
    currency = Coinbase::Currency.find_by symbol: symbol
    return currency if currency.present?

    currency_response = coinbase_client.currency(symbol)
    return unless currency_response.present?

    Coinbase::Currency.create currency_response
  end

  def populate_pairs_result(search)
    search.result = PairBlueprint.render_as_hash pairs.limit(limit).paginated(cursor)
    search.save
  end

  def pairs
    return @pairs if @pairs

    query = Coinbase::Pair.includes(:base_currency, :quote_currency).order(pairs_sort || :symbols)
    query = query.search_by_symbols(query_params[:symbols]) if query_params[:symbols].present?
    query = query.search_by_base_currency(query_params[:base_currency]) if query_params[:base_currency].present?
    query = query.search_by_quote_currency(query_params[:quote_currency]) if query_params[:quote_currency].present?

    @pairs = query
  end

  def pairs_sort
    return sort unless sort&.include?('currency')

    column, direction = sort.split(' ')
    column_name = column == 'base_currency' ? 'coinbase_currencies.name' : "#{column.pluralize}_coinbase_pairs.name"
    [[column_name, direction].join(' '), ['symbols', direction].join(' ')]
  end

  def populate_currencies
    existing_currency_names = Coinbase::Currency.all.map(&:name)

    currencies_to_persist = coinbase_client.currencies.reject do |c|
      existing_currency_names.include?(c[:name])
    end

    currencies_to_persist.each do |c|
      Coinbase::Currency.create(c)
    end
  end

  def populate_currencies_result(search)
    search.result = CurrencyBlueprint.render_as_hash currencies_by_name.limit(limit).paginated(cursor)
    search.save
  end

  def currencies_by_name
    return @currencies_by_name if @currencies_by_name

    query = Coinbase::Currency.order(sort || :name)
    query = query.search_by_name(query_params[:name]) if query_params[:name].present?
    query = query.search_by_symbol(query_params[:symbol]) if query_params[:symbol].present?

    @currencies_by_name = query
  end

  def calculate_cursor(search)
    case search.search_type
    when Search::SEARCH_TYPES[:currencies]
      currencies_cursor(search)
    when Search::SEARCH_TYPES[:pairs]
      pairs_cursor(search)
    when Search::SEARCH_TYPES[:rates]
      rates_cursor(search)
    end
  end

  def currencies_cursor(search)
    previous_name = first_search_result_name(search) == first_currency_name ? nil : first_search_result_name(search)
    next_name = last_search_result_name(search) == last_currency_name ? nil : last_search_result_name(search)
    cursor_hash(previous_name, next_name)
  end

  def pairs_cursor(search)
    previous_symbols = first_search_result_symbols(search) == first_pair_symbols ? nil : first_search_result_symbols(search)
    next_symbols = last_search_result_symbols(search) == last_pair_symbols ? nil : last_search_result_symbols(search)
    cursor_hash(previous_symbols, next_symbols)
  end

  def rates_cursor(search)
    previous_time = first_search_result_time(search) == first_rate_time ? rates_previous_time : first_search_result_time(search)
    next_time = last_search_result_time(search) == last_rate_time ? rates_next_time : last_search_result_time(search)
    cursor_hash(previous_time, next_time)
  end

  def rates_next_time
    sort&.include?('DESC') ? last_rate_time : nil
  end

  def rates_previous_time
    sort&.include?('DESC') ? nil : first_rate_time
  end

  def first_search_result_time(search)
    @first_search_result_rates ||= search.result.any? && Time.parse(search.result.first['time']).to_i
  end

  def last_search_result_time(search)
    @last_search_result_rates ||= search.result.any? && Time.parse(search.result.last['time']).to_i
  end

  def first_search_result_symbols(search)
    @first_search_result_symbols ||= search.result.any? && search.result.first['symbols']
  end

  def last_search_result_symbols(search)
    @last_search_result_symbols ||= search.result.any? && search.result.last['symbols']
  end

  def first_search_result_name(search)
    @first_search_result_name ||= search.result.any? && search.result.first['name']
  end

  def last_search_result_name(search)
    @last_search_result_name ||= search.result.any? && search.result.last['name']
  end

  def first_pair_symbols
    pairs.first&.symbols
  end

  def last_pair_symbols
    pairs.last&.symbols
  end

  def first_currency_name
    currencies_by_name.first&.name
  end

  def last_currency_name
    currencies_by_name.last&.name
  end

  def first_rate_time
    rates.first&.time&.to_i
  end

  def last_rate_time
    rates.last&.time&.to_i
  end

  def cursor_hash(previous, subsequent)
    {
      previous_page: previous && Base64.strict_encode64("#{sort&.include?('DESC') ? 'after' : 'before'}__#{previous}"),
      next_page: subsequent && Base64.strict_encode64("#{sort&.include?('DESC') ? 'before' : 'after'}__#{subsequent}")
    }
  end
end
