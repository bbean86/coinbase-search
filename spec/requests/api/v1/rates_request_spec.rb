require 'rails_helper'

RSpec.describe 'Api::V1::Rates', type: :request do
  it 'returns a list of rates for the pair' do
    get '/api/v1/pairs/BTC-USD/rates', { headers: { Accept: 'application/json' }, params: { cursor: 'YmVmb3JlX18xNTA4MTgwNDYw\n' } }

    expect(response.status).to eql(200)
    expect(JSON.parse(response.body)).to eql(JSON.parse(file_fixture('rates_api_response.json').read))
  end
end
