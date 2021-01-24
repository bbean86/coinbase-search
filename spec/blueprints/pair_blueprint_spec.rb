require 'rails_helper'

describe PairBlueprint, '#render_as_hash' do
  let(:btc) { Coinbase::Currency.create name: 'Bitcoin', symbol: 'BTC' }
  let(:usd) { Coinbase::Currency.create name: 'United States Dollar', symbol: 'USD' }
  let(:btc_usd) { Coinbase::Pair.create base_currency: btc, quote_currency: usd, symbols: 'BTC-USD', status: 'online' }
  let(:result) { PairBlueprint.render_as_hash(btc_usd) }

  it 'returns status, symbols, base_currency name, and quote_currency name for the pair' do
    expect(result).to eq({ status: 'online', symbols: 'BTC-USD', base_currency: btc.name, quote_currency: usd.name })
  end
end
