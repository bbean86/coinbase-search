require 'rails_helper'
require 'shared_examples_for_searchable'

RSpec.describe 'Api::V1::Currencies', type: :request do
  describe 'GET /api/v1/currencies' do
    it 'returns a list of all currencies' do
      get '/api/v1/currencies', { headers: { Accept: 'application/json' } }

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body)).to eql(JSON.parse(file_fixture('currencies_api_response.json').read))
    end

    it_behaves_like 'a searchable index', '/api/v1/currencies'
  end
end
