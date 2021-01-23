class ExecuteSearch
  def self.call(params)
    instance = new(params)
    instance.execute
  end

  attr_reader :search_type, :limit, :cursor, :expires_at, :query_params

  def initialize(params)
    @search_type = params.delete :search_type
    @limit = params.delete :limit
    @cursor = params.delete :cursor
    @expires_at = params.delete :expires_at
    @query_params = params
  end

  def execute
    if existing_search.nil?
      search = Search.new(search_type: search_type, query_params: query_params, expires_at: expires_at)
      search.query_coinbase
      search.result
    else
      existing_search.result
    end
  end

  private

  def existing_search
    @existing_search ||= Rails.cache.fetch(cache_key) do
      s = Search
          .by_type(search_type)
          .by_query(query_params)
          .by_limit_and_cursor(limit, cursor)
          .first

      return s unless s.present? && s.expires_at <= Time.now

      s.query_coinbase
    end
  end

  def cache_key
    params = query_params.each_with_object([]) do |p, acc|
      acc.push("#{p[0]}:#{p[1]}")
    end.join('-')

    "#{search_type}-#{params}"
  end
end
