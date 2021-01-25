require 'rails_helper'

RSpec.describe 'Api::V1::Pairs', type: :request do
  it 'returns a list of all pairs' do
    get '/api/v1/pairs', { headers: { Accept: 'application/json' } }

    expect(response.status).to eql(200)
    expect(JSON.parse(response.body)).to eql(JSON.parse(file_fixture('pairs_api_response.json').read))
  end
end
