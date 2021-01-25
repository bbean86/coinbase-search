class CoinbaseClient
  module Connection
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
  end
end
