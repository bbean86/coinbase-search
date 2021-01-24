require 'swagger_helper'

describe 'Pairs API' do
  path '/api/v1/pairs' do
    get 'Returns matching pairs from Coinbase Pro' do
      tags 'Pairs'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :symbols, in: :query, type: :string, description: 'contains symbols or a portion of symbols for desired pair to filter by'
      parameter name: :base_currency, in: :query, type: :string, description: 'contains the name or a portion of the name of a currency to filter on base currency'
      parameter name: :quote_currency, in: :query, type: :string, description: 'contains the name or a portion of the name of a currency to filter on quote currency'
      parameter name: :limit, in: :query, type: :integer, description: 'indicates the maximum number of records the API should return'
      parameter name: :cursor, in: :query, type: :string, description: 'contains the cursor for pagination to start from, in Base64'
      parameter name: :sort, in: :query, type: :string, description: 'indicates the property and direction to sort the results on'

      let(:limit) { 10 }
      let(:cursor) { Base64.encode64('before__Bitcoin') }
      let(:sort) { 'symbols DESC' }
      let(:base_currency) { nil }
      let(:quote_currency) { nil }

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
        let(:symbols) { 'BTC' }

        run_test!
      end

      response '422', 'malformed request' do
        let(:symbols) { 'BTC' }
        let(:sort) { 'foo ASC' }

        run_test!
      end

      response '404', 'pairs not found' do
        let(:symbols) { 'foobar' }

        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:Accept) { 'application/foo' }
        let(:symbols) { 'BTC' }

        run_test!
      end
    end
  end
end
