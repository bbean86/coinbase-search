require 'rails_helper'

RSpec.describe Coinbase::Pair, type: :model do
  it { is_expected.to validate_presence_of :base_currency }
  it { is_expected.to validate_presence_of :quote_currency }
  it { is_expected.to validate_presence_of :symbols }
  it { is_expected.to validate_presence_of :status }

  let(:btc) { Coinbase::Currency.create name: 'Bitcoin', symbol: 'BTC' }
  let(:usd) { Coinbase::Currency.create name: 'United States Dollar', symbol: 'USD' }
  let(:eth) { Coinbase::Currency.create name: 'Ether', symbol: 'ETH' }
  let(:aave) { Coinbase::Currency.create name: 'Aave', symbol: 'AAVE' }
  let!(:aave_btc) { Coinbase::Pair.create base_currency: aave, quote_currency: btc, symbols: 'AAVE-BTC', status: 'online' }
  let!(:btc_usd) { Coinbase::Pair.create base_currency: btc, quote_currency: usd, symbols: 'BTC-USD', status: 'online' }
  let!(:eth_usd) { Coinbase::Pair.create base_currency: eth, quote_currency: usd, symbols: 'ETH-USD', status: 'online' }

  describe '.search_by_symbols' do
    let(:btc_search) { Coinbase::Pair.order(:symbols).search_by_symbols('BTC') }
    let(:usd_search) { Coinbase::Pair.order(:symbols).search_by_symbols('USD') }

    it 'returns a list of Pairs matching the symbol' do
      expect(btc_search).to eq([aave_btc, btc_usd])
      expect(usd_search).to eq([btc_usd, eth_usd])
    end
  end

  describe '.search_by_base_currency' do
    let(:bit_search) { Coinbase::Pair.order(:symbols).search_by_base_currency('Bit') }
    let(:eth_search) { Coinbase::Pair.order(:symbols).search_by_base_currency('Eth') }

    it 'returns a list of Pairs matching the symbol' do
      expect(bit_search).to eq([btc_usd])
      expect(eth_search).to eq([eth_usd])
    end
  end

  describe '.search_by_quote_currency' do
    let(:bit_search) { Coinbase::Pair.order(:symbols).search_by_quote_currency('Bit') }
    let(:united_search) { Coinbase::Pair.order(:symbols).search_by_quote_currency('United') }

    it 'returns a list of Pairs matching the symbol' do
      expect(bit_search).to eq([aave_btc])
      expect(united_search).to eq([btc_usd, eth_usd])
    end
  end

  describe '.paginated' do
    let(:result) { Coinbase::Pair.paginated(Base64.encode64('after__BTC-USD')) }

    it 'returns Pairs indicated by the cursor' do
      expect(result).to eq([eth_usd])
    end
  end
end
