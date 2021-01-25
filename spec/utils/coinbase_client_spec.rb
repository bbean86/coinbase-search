require 'rails_helper'

describe CoinbaseClient do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) { CoinbaseClient.new conn }

  describe '#currencies' do
    it 'returns the list of currencies' do
      stubs.get('/currencies') do
        [
          200,
          { 'Content-Type': 'application/json' },
          file_fixture('currencies_response.json').read
        ]
      end

      expect(client.currencies).to eq([
                                        {
                                          name: 'Euro',
                                          symbol: 'EUR'
                                        },
                                        {
                                          name: 'British Pound',
                                          symbol: 'GBP'
                                        },
                                        {
                                          name: 'Celo',
                                          symbol: 'CGLD'
                                        },
                                        {
                                          name: 'Compound',
                                          symbol: 'COMP'
                                        },
                                        {
                                          name: 'Aave',
                                          symbol: 'AAVE'
                                        },
                                        {
                                          name: 'Bitcoin',
                                          symbol: 'BTC'
                                        },
                                        {
                                          name: 'United States Dollar',
                                          symbol: 'USD'
                                        },
                                        {
                                          name: 'Wrapped Bitcoin',
                                          symbol: 'WBTC'
                                        },
                                        {
                                          name: 'Bitcoin Cash',
                                          symbol: 'BCH'
                                        }
                                      ])
      stubs.verify_stubbed_calls
    end
  end

  describe '#currency' do
    it 'returns the currency by symbol' do
      stubs.get('/currencies') do
        [
          200,
          { 'Content-Type': 'application/json' },
          file_fixture('currencies_response.json').read
        ]
      end

      expect(client.currency('BTC')).to eq({ name: 'Bitcoin', symbol: 'BTC' })
      stubs.verify_stubbed_calls
    end
  end

  describe '#pairs' do
    it 'returns the list of pairs' do
      stubs.get('/products') do
        [
          200,
          { 'Content-Type' => 'application/json' },
          file_fixture('products_response.json').read
        ]
      end

      expect(client.pairs).to eql([
                                    {
                                      base_currency: 'COMP',
                                      quote_currency: 'USD',
                                      status: 'online',
                                      symbols: 'COMP-USD'
                                    },
                                    {
                                      base_currency: 'CGLD',
                                      quote_currency: 'USD',
                                      status: 'online',
                                      symbols: 'CGLD-USD'
                                    },
                                    {
                                      base_currency: 'AAVE',
                                      quote_currency: 'BTC',
                                      status: 'online',
                                      symbols: 'AAVE-BTC'
                                    },
                                    {
                                      base_currency: 'AAVE',
                                      quote_currency: 'GBP',
                                      status: 'online',
                                      symbols: 'AAVE-GBP'
                                    },
                                    {
                                      base_currency: 'AAVE',
                                      quote_currency: 'USD',
                                      status: 'online',
                                      symbols: 'AAVE-USD'
                                    },
                                    {
                                      base_currency: 'AAVE',
                                      quote_currency: 'EUR',
                                      status: 'online',
                                      symbols: 'AAVE-EUR'
                                    }
                                  ])
      stubs.verify_stubbed_calls
    end
  end
end
