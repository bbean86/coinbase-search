require 'swagger_helper'

describe 'Currencies API' do
  after do |example|
    example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
  end

  path '/currencies' do
    get 'Searches for the currency on Coinbase Pro' do
      tags 'Currencies'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :name, in: :query, type: :string
      parameter name: :limit, in: :query, type: :integer
      parameter name: :cursor, in: :query, type: :string

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
        let(:name) { 'Bit' }

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
    end
  end
end
