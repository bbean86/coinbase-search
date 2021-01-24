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
      headers: {
        'Content-Type' => 'application/json',
        'CB-ACCESS-KEY' => ENV['CB_ACCESS_KEY'],
        'CB-ACCESS-PASSPHRASE' => ENV['CB_ACCESS_PASSPHRASE']
      }
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

    'currencies/' + Digest::SHA1.hexdigest("#{search_type}-#{params}-#{limit}-#{cursor}-#{search.expires_at}")
  end

  def populate_result(search)
    case search.search_type
    when Search::SEARCH_TYPES[:currencies]
      populate_currencies
      populate_currencies_result(search)
    else
      raise "#{search.search_type} search not yet implemented"
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
    end
  end

  def currencies_by_name
    @currencies_by_name ||= if query_params['name'].present?
                              Coinbase::Currency.order(:name).search_by_name(query_params['name'])
                            else
                              Coinbase::Currency.order(:name)
                            end
  end

  def currencies_cursor(search)
    previous_name = first_search_result_name(search) == first_currency_name ? nil : first_search_result_name(search)
    next_name = last_search_result_name(search) == last_currency_name ? nil : last_search_result_name(search)
    cursor_hash(previous_name, next_name)
  end

  def first_search_result_name(search)
    @first_search_result_name ||= search.result.any? && search.result.first['name']
  end

  def last_search_result_name(search)
    @last_search_result_name ||= search.result.any? && search.result.last['name']
  end

  def first_currency_name
    currencies_by_name.first&.name
  end

  def last_currency_name
    currencies_by_name.last&.name
  end

  def cursor_hash(previous_name, next_name)
    unless next_name
      return {
        previous_page: nil,
        next_page: nil
      }
    end

    {
      previous_page: previous_name && Base64.encode64("before__#{previous_name}"),
      next_page: Base64.encode64("after__#{next_name}")
    }
  end
end
