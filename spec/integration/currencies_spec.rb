require 'swagger_helper'

describe 'Currencies API' do
  path '/api/v1/currencies' do
    get 'Returns matching currencies from Coinbase Pro' do
      tags 'Currencies'
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]

      parameter name: :name,
                in: :query,
                type: :string,
                description: 'contains a currency name or portion of name to filter on',
                example: 'b'

      parameter name: :symbol,
                in: :query,
                type: :string,
                description: 'contains a symbol or portion of a symbol to filter on',
                example: 'b'

      parameter name: :limit,
                in: :query,
                type: :integer,
                description: 'indicates the maximum number of records the API should return',
                default: 50,
                example: 10,
                minimum: 0,
                maximum: 500

      parameter name: :cursor,
                in: :query,
                type: :string,
                description: 'contains the cursor for pagination to start from, in Base64',
                example: CGI.escape(Base64.encode64('after__Bitcoin'))

      parameter name: :sort,
                in: :query,
                type: :string,
                description: 'indicates the property and direction to sort the results on',
                example: 'name DESC',
                enum: Coinbase::Currency.allowed_sort_columns

      let(:limit) { 10 }
      let(:cursor) { Base64.encode64('before__Bitcoin') }
      let(:sort) { 'name DESC' }
      let(:symbol) { '' }
      let(:Authorization) { 'Bearer 73e2f213f7d875e9e62798b61d3c275ec63f2efe' }
      let(:name) { 'B' }

      response '200', 'currencies found' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       name: { type: :string },
                       symbol: { type: :string }
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

      response '404', 'currencies not found' do
        let(:name) { 'foobar' }

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
end
