require 'rails_helper'
require 'shared_examples_for_searchable'

RSpec.describe 'Api::V1::Pairs', type: :request do
  it 'returns a list of all pairs' do
    get '/api/v1/pairs', { headers: { Accept: 'application/json' } }

    expect(response.status).to eql(200)
    expect(JSON.parse(response.body)).to eql(JSON.parse(file_fixture('pairs_api_response.json').read))
  end

  it_behaves_like 'a searchable index', '/api/v1/pairs'
end
