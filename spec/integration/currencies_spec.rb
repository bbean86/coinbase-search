require 'swagger_helper'

describe 'Currencies API' do
  path '/api/v1/currencies' do
    get 'Searches for the currency on Coinbase Pro' do
      tags 'Currencies'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :name, in: :query, type: :string, description: 'contains a currency name or portion of name'
      parameter name: :limit, in: :query, type: :integer, description: 'indicates the maximum number of records the API should return'
      parameter name: :cursor, in: :query, type: :string, description: 'contains the cursor for pagination to start from, in Base64'

      let(:limit) { 10 }
      let(:cursor) { Base64.encode64('before__Bitcoin') }

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
                     next_page: { type: :string },
                     previous_page: { type: :string }
                   }
                 }
               }
        let(:name) { 'B' }

        run_test!
      end

      response '404', 'currencies not found' do
        let(:name) { 'foobar' }

        # before do
        #   allow(ExecuteSearch).to receive(:call).and_return(nil)
        # end

        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:Accept) { 'application/foo' }
        let(:name) { 'Bit' }
        run_test!
      end
    end
  end
end
