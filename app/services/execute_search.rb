class ExecuteSearch
  def self.call(params)
    instance = new(params)
    instance.execute
  end

  attr_reader :search_type, :limit, :cursor, :expires_at, :query_params, :coinbase_client

  def initialize(params, adapter = :net_http, stubs = nil)
    @search_type = params.delete(:search_type).to_s
    @limit = params.delete :limit
    @cursor = params.delete :cursor
    @expires_at = params.delete :expires_at
    @query_params = params
    @coinbase_client = CoinbaseClient.new conn(adapter, stubs)
  end

  def execute
    if existing_search.nil?
      search = Search.new(search_type: search_type, query_params: query_params, expires_at: expires_at)
      populate_result(search)

      return nil unless search.result.present?

      {
        data: search.result
      }
    else
      return nil unless existing_search.result.present?

      {
        data: existing_search.result
      }
    end
  end

  private

  def conn(adapter, stubs)
    Faraday.new(connection_opts) do |builder|
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
    @existing_search ||= Rails.cache.fetch(cache_key) do
      s = Search
          .by_type(search_type)
          .by_query(query_params)
          .by_limit_and_cursor(limit, cursor)
          .first

      return s unless s.present? && s.expires_at <= Time.now

      populate_result(s)
    end
  end

  def cache_key
    params = query_params.each_with_object([]) do |p, acc|
      acc.push("#{p[0]}:#{p[1]}")
    end.join('-')

    Digest::SHA1.hexdigest "#{search_type}-#{params}-#{limit}-#{cursor}"
  end

  def populate_result(search)
    case search.search_type
    when Search::SEARCH_TYPES[:currencies]
      populate_currencies
      populate_currency_result(search)
    else
      raise "#{search.search_type} search not yet implemented"
    end
  end

  def populate_currencies
    currencies_to_persist = coinbase_client.currencies.reject do |c|
      Coinbase::Currency.find_by(name: c[:name]).present?
    end

    currencies_to_persist.each do |c|
      Coinbase::Currency.create(c)
    end
  end

  def populate_currency_result(search)
    search.result = Coinbase::Currency.search_by_name(query_params['name']).limit(limit).map(&:as_json)
    search.save
  end
end
