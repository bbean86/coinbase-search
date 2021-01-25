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

    JSON.parse(response.body).each_with_object([]) do |p, acc|
      acc << {
        symbols: p['id'],
        base_currency: p['base_currency'],
        quote_currency: p['quote_currency'],
        status: p['status']
      }
    end
  end

  def pair(symbols)
    response = conn.get("/products/#{symbols}")

    return nil unless response.body.present?

    result = JSON.parse(response.body)

    {
      symbols: result['id'],
      base_currency: result['base_currency'],
      quote_currency: result['quote_currency'],
      status: result['status']
    }
  end

  def rates(symbols, rates_start, rates_end, interval)
    interval ||= 60
    response = conn.get("/products/#{symbols}/candles") do |req|
      req.params['start'] = rates_start if rates_start
      req.params['end'] = rates_end if rates_end
      req.params['granularity'] = interval
    end

    return [] unless response.status == 200

    JSON.parse(response.body).each_with_object([]) do |rate, acc|
      acc << {
        symbols: symbols,
        interval: interval,
        time: Time.at(rate[0]),
        low: rate[1],
        high: rate[2],
        open: rate[3],
        close: rate[4],
        volume: rate[5]
      }
    end
  end
end
