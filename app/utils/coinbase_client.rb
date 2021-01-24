class CoinbaseClient
  attr_reader :conn

  def initialize(conn)
    @conn = conn
  end

  def currencies
    response = conn.get('/currencies')

    return [] unless response.body.present?

    JSON.parse(response.body).each_with_object([]) do |currency, acc|
      acc << { name: currency['name'], symbol: currency['id'] }
    end
  end

  def currency(symbol)
    # takes advantage of HTTP response caching to avoid rate limit
    response = conn.get('/currencies')

    return nil unless response.body.present?

    result = JSON.parse(response.body).find(-> { {} }) { |c| c['id'] == symbol }

    {
      name: result['name'],
      symbol: result['id']
    }
  end

  def pairs
    response = conn.get('/products')

    return [] unless response.body.present?

    JSON.parse(response.body).each_with_object([]) do |pair, acc|
      acc << {
        symbols: pair['id'],
        base_currency: pair['base_currency'],
        quote_currency: pair['quote_currency'],
        status: pair['status']
      }
    end
  end
end
