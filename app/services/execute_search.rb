class ExecuteSearch
  include CoinbaseClient::Connection
  include PopulateResult
  include CursorPagination

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

    search = Search.new search_type: search_type,
                        query_params: query_params,
                        expires_at: expires_at,
                        limit: limit,
                        cursor: cursor,
                        sort: sort

    return { errors: search.errors } unless search.valid?

    populate_result(search)
    search_result_hash(search)
  end

  private

  def search_result_hash(search)
    Rails.cache.fetch(cache_key(search)) do
      return nil unless search.result.present?

      {
        data: search.result,
        cursor: calculate_cursor(search)
      }
    end
  end

  def existing_search
    return @existing_search if @existing_search

    @existing_search = Search
                       .by_type(search_type)
                       .by_query(query_params)
                       .by_limit_and_cursor(limit, cursor)
                       .by_sort(sort)
                       .first

    return @existing_search unless @existing_search.present? && @existing_search.expires_at <= Time.now

    populate_result(@existing_search)
  end

  def cache_key(search)
    params = query_params.each_with_object([]) do |kvp, acc|
      acc.push(kvp.join(':'))
    end.join('-')

    key = Digest::SHA1.hexdigest([search_type, params, sort, limit, cursor, search.expires_at].join(';'))

    [search_type, key].join('/')
  end
end
