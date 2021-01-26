require 'rails_helper'

RSpec.describe Coinbase::Rate, type: :model do
  it { is_expected.to belong_to :pair }

  let(:btc) { Coinbase::Currency.create symbol: 'BTC', name: 'Bitcoin' }
  let(:usd) { Coinbase::Currency.create symbol: 'USD', name: 'United States Dollar' }
  let(:eth) { Coinbase::Currency.create symbol: 'ETH', name: 'Ether' }

  let(:btc_usd) { Coinbase::Pair.create symbols: 'BTC-USD', base_currency: btc, quote_currency: usd, status: 'online' }
  let(:eth_usd) { Coinbase::Pair.create symbols: 'ETH-USD', base_currency: eth, quote_currency: usd, status: 'online' }

  let!(:btc_rate) do
    Coinbase::Rate.create pair: btc_usd, low: 31_885.88, high: 31_919.65, open: 31_911.23, close: 31_910.06,
                          volume: 6.24052656, interval: 60, time: Time.now - 1.day
  end
  let!(:eth_rate) do
    Coinbase::Rate.create pair: eth_usd, low: 1435.25, high: 1440.0, open: 1435.67, close: 1438.5, volume: 596.98884737,
                          interval: 60, time: Time.now
  end

  describe '.by_symbols' do
    let(:result) { Coinbase::Rate.by_symbols('BTC-USD') }

    it 'finds Rates by their symbols' do
      expect(result).to eq([btc_rate])
    end
  end

  describe '.by_interval' do
    let(:result) { Coinbase::Rate.by_interval(60) }

    it 'finds Rates by their interval' do
      expect(result).to eq([btc_rate, eth_rate])
    end
  end

  describe '.paginated' do
    let(:result) { Coinbase::Rate.paginated(Base64.strict_encode64("before__#{eth_rate.time.to_i}")) }

    it 'finds Rates indicated by the cursor' do
      expect(result).to eq([btc_rate])
    end
  end
end
