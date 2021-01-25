require 'rails_helper'

RSpec.describe 'Api::V1::Currencies', type: :request do
  describe 'GET /api/v1/currencies' do
    it 'returns a list of all currencies' do
      get '/api/v1/currencies', { headers: { Accept: 'application/json' } }

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body)).to eql(JSON.parse(file_fixture('currencies_api_response.json').read))
    end

    it 'handles an invalid limit parameter' do
      get '/api/v1/currencies', { headers: { Accept: 'application/json' }, params: { limit: -1 } }

      expect(response.status).to eql(422)
      expect(JSON.parse(response.body)).to eql({ 'message' => 'Limit must be greater than 0' })
    end
  end
end
