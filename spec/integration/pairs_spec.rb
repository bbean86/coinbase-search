require 'swagger_helper'

describe 'Pairs API' do
  let(:Authorization) { 'Bearer 73e2f213f7d875e9e62798b61d3c275ec63f2efe' }

  path '/api/v1/pairs' do
    get 'Returns matching pairs from Coinbase Pro' do
      tags 'Pairs'
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]

      parameter name: :symbols,
                in: :query,
                type: :string,
                description: 'contains symbols or a portion of symbols for desired pair to filter by',
                example: 'b'

      parameter name: :base_currency,
                in: :query,
                type: :string,
                description: 'contains the name or a portion of the name of a currency to filter on base currency',
                example: 'b'

      parameter name: :quote_currency,
                in: :query,
                type: :string,
                description: 'contains the name or a portion of the name of a currency to filter on quote currency',
                example: 'u'

      parameter name: :limit,
                in: :query,
                type: :integer,
                description: 'indicates the maximum number of records the API should return',
                example: 10

      parameter name: :cursor,
                in: :query,
                type: :string,
                description: 'contains the cursor for pagination to start from, in Base64',
                example: CGI.escape(Base64.encode64('before__BTC-USD'))

      parameter name: :sort,
                in: :query,
                type: :string,
                description: 'indicates the property and direction to sort the results on',
                example: 'symbols DESC',
                enum: Coinbase::Pair.allowed_sort_columns

      let(:limit) { 10 }
      let(:cursor) { Base64.encode64('before__BTC-USD') }
      let(:sort) { 'symbols DESC' }
      let(:base_currency) { nil }
      let(:quote_currency) { nil }
      let(:symbols) { 'BTC' }

      response '200', 'pairs found' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       symbols: { type: :string },
                       base_currency: { type: :string },
                       quote_currency: { type: :string },
                       status: { type: :string }
                     }
                   }
                 },
                 cursor: {
                   type: :object,
                   properties: {
                     next_page: {
                       oneOf: [
                         { type: :string },
                         { type: :null }
                       ]
                     },
                     previous_page: {
                       oneOf: [
                         { type: :string },
                         { type: :null }
                       ]
                     }
                   }
                 }
               }

        run_test!
      end

      response '422', 'malformed request' do
        let(:sort) { 'foo ASC' }

        run_test!
      end

      response '404', 'pairs not found' do
        let(:symbols) { 'foobar' }

        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:Accept) { 'application/foo' }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { '' }

        run_test!
      end
    end
  end

  path '/api/v1/pairs/{symbols}/rates' do
    get 'Returns historical rates in candlestick form for pair from Coinbase Pro' do
      tags 'Pairs'
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]

      parameter name: :symbols,
                in: :path,
                type: :string,
                description: 'indicates the pair to get rates for by its symbols',
                example: 'BTC-USD'

      parameter name: :limit,
                in: :query,
                type: :integer,
                description: 'indicates the maximum number of records the API should return'

      parameter name: :cursor,
                in: :query,
                type: :string,
                description: 'contains the cursor for pagination to start from, in Base64',
                example: CGI.escape(Base64.encode64("before__#{Time.now.to_i}"))

      parameter name: :sort,
                in: :query,
                type: :string,
                description: 'indicates the property and direction to sort the results on',
                example: 'time ASC'

      parameter name: :interval,
                in: :query,
                type: :integer,
                description: 'contains an integer indicating rate interval in seconds to build candlesticks from',
                enum: [60, 300, 900, 3600, 21_600, 86_400],
                example: 60

      let(:limit) { 10 }
      let(:cursor) { Base64.encode64("before__#{Time.now.to_i}") }
      let(:sort) { 'time ASC' }
      let(:interval) { 60 }
      let(:symbols) { 'BTC-USD' }

      response '200', 'rates found' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       time: { type: :string, format: 'date-time' },
                       low: { type: :string },
                       high: { type: :string },
                       open: { type: :string },
                       close: { type: :string },
                       volume: { type: :string }
                     }
                   }
                 },
                 cursor: {
                   type: :object,
                   properties: {
                     next_page: {
                       oneOf: [
                         { type: :string },
                         { type: :null }
                       ]
                     },
                     previous_page: {
                       oneOf: [
                         { type: :string },
                         { type: :null }
                       ]
                     }
                   }
                 }
               }

        run_test!
      end

      response '404', 'pair not found' do
        let(:symbols) { 'invalid' }

        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:Accept) { 'application/foo' }

        run_test!
      end

      response '422', 'malformed request' do
        let(:sort) { 'foo ASC' }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { '' }

        run_test!
      end
    end
  end
end
