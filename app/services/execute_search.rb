class ExecuteSearch
  def self.call(params)
    instance = new(params)
    instance.execute
  end

  attr_reader :search_type, :limit, :cursor, :expires_at, :query_params, :coinbase_client

  def initialize(params, adapter = :net_http, stubs = nil)
    params = params.with_indifferent_access
    @search_type = params.delete(:search_type).to_s
    @limit = params.delete(:limit) || 50
    @cursor = params.delete :cursor
    @expires_at = params.delete :expires_at
    @query_params = params
    @coinbase_client = CoinbaseClient.new conn(adapter, stubs)
  end

  def execute
    return search_result_hash(existing_search) if existing_search.present?

    search = new_search
    populate_result(search)
    search_result_hash(search)
  end

  private

  def new_search
    Search.new search_type: search_type,
               query_params: query_params,
               expires_at: expires_at,
               limit: limit,
               cursor: cursor
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
        .first

    return s unless s.present? && s.expires_at <= Time.now

    populate_result(s)
    @existing_search = s
  end

  def cache_key(search)
    params = query_params.each_with_object([]) do |p, acc|
      acc.push("#{p[0]}:#{p[1]}")
    end.join('-')

    "#{search_type}/" + Digest::SHA1.hexdigest("#{search_type}-#{params}-#{limit}-#{cursor}-#{search.expires_at}")
  end

  def populate_result(search)
    case search.search_type
    when Search::SEARCH_TYPES[:currencies]
      populate_currencies
      populate_currencies_result(search)
    when Search::SEARCH_TYPES[:pairs]
      populate_pairs
      populate_pairs_result(search)
    else
      raise "#{search.search_type} search not yet implemented"
    end
  end

  def populate_pairs
    existing_pair_names = Coinbase::Pair.all.map(&:symbols)

    pairs_to_persist = coinbase_client.pairs.reject do |c|
      existing_pair_names.include?(c[:symbols])
    end

    pairs_to_persist.each do |p|
      p[:base_currency] = Coinbase::Currency.find_by symbol: p[:base_currency]
      p[:quote_currency] = Coinbase::Currency.find_by symbol: p[:quote_currency]
      Coinbase::Pair.create(p)
    end
  end

  def populate_pairs_result(search)
    search.result = pairs.limit(limit).paginated(cursor).to_a.map do |c|
      c.as_json(only: %i[symbols status]).merge(base_currency: c.base_currency.name, quote_currency: c.quote_currency.name)
    end
    search.save
  end

  def pairs
    return @pairs if @pairs

    query = Coinbase::Pair.includes(:base_currency, :quote_currency).order(:symbols)

    @pairs =
      if query_params[:symbols].present?
        query.search_by_symbols(query_params[:symbols])
      elsif query_params[:base_currency].present?
        query.search_by_base_currency(query_params[:base_currency])
      elsif query_params[:quote_currency].present?
        query.search_by_quote_currency(query_params[:quote_currency])
      else
        query
      end
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
    search.result = currencies_by_name.limit(limit).paginated(cursor).to_a.map do |c|
      c.as_json(only: %i[name symbol])
    end
    search.save
  end

  def calculate_cursor(search)
    case search.search_type
    when Search::SEARCH_TYPES[:currencies]
      currencies_cursor(search)
    when Search::SEARCH_TYPES[:pairs]
      pairs_cursor(search)
    end
  end

  def currencies_by_name
    @currencies_by_name ||= if query_params[:name].present?
                              Coinbase::Currency.order(:name).search_by_name(query_params[:name])
                            else
                              Coinbase::Currency.order(:name)
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

  def cursor_hash(previous, subsequent)
    unless subsequent || previous
      return {
        previous_page: nil,
        next_page: nil
      }
    end

    {
      previous_page: previous && Base64.encode64("before__#{previous}"),
      next_page: subsequent && Base64.encode64("after__#{subsequent}")
    }
  end
end
