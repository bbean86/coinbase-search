require 'rails_helper'
require 'shared_examples_for_searchable'

RSpec.describe 'Api::V1::Rates', type: :request do
  it 'returns a list of rates for the pair' do
    get '/api/v1/pairs/BTC-USD/rates', { headers: { Accept: 'application/json' }, params: { cursor: 'YmVmb3JlX18xNTA4MTgwNDYw' } }

    expect(response.status).to eql(200)
    expect(JSON.parse(response.body)).to eql(JSON.parse(file_fixture('rates_api_response.json').read))
  end

  it_behaves_like 'a searchable index', '/api/v1/pairs/BTC-USD/rates'
end
