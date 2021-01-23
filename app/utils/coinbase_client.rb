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
end
