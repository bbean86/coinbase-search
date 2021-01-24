require 'rails_helper'

describe CurrencyBlueprint, '#render_as_hash' do
  let(:btc) { Coinbase::Currency.create name: 'Bitcoin', symbol: 'BTC' }
  let(:result) { CurrencyBlueprint.render_as_hash(btc) }

  it 'returns name and symbol for the currency' do
    expect(result).to eq({ name: 'Bitcoin', symbol: 'BTC' })
  end
end
