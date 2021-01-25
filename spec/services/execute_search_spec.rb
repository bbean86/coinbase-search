require 'rails_helper'

describe ExecuteSearch do
  describe '.call' do
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }

    before do
      stubs.get('/currencies') do
        [
          200,
          { 'Content-Type': 'application/json' },
          file_fixture('currencies_response.json').read
        ]
      end

      stubs.get('/products') do
        [
          200,
          { 'Content-Type' => 'application/json' },
          file_fixture('products_response.json').read
        ]
      end

      stubs.get('/products/BTC-USD') do
        [
          200,
          { 'Content-Type' => 'application/json' },
          file_fixture('btc_usd_response.json').read
        ]
      end

      stubs.get('/products/BTC-USD/candles') do
        [
          200,
          { 'Content-Type' => 'application/json' },
          file_fixture('btc_usd_candles_response.json').read
        ]
      end
    end

    let!(:search) do
      Search.create search_type: 'currencies',
                    query_params: { name: 'Bit' },
                    result: [{ name: 'Bitcon', symbol: 'BTC' }],
                    expires_at: Time.now + 1.hour
    end
    let(:result) { ExecuteSearch.call({ search_type: :currencies, name: 'Bit', expires_at: Time.now + 1.day }, :test, stubs) }

    it 'finds an existing Search by the given search_type and query params' do
      expect(result[:data]).to_not be_empty
    end

    context 'sorting currencies by name DESC' do
      let(:result) { ExecuteSearch.call({ search_type: :currencies, name: 'Bit', sort: 'name DESC', expires_at: Time.now + 1.day }, :test, stubs) }

      it 'returns the Currencies in the correct order' do
        expect(result[:data]).to eq([
                                      {
                                        'name' => 'Wrapped Bitcoin',
                                        'symbol' => 'WBTC'
                                      }, {
                                        'name' => 'Bitcoin Cash',
                                        'symbol' => 'BCH'
                                      }, {
                                        'name' => 'Bitcoin',
                                        'symbol' => 'BTC'
                                      }
                                    ])
      end
    end

    context 'pagination' do
      context 'for URI encoded cursors' do
        let(:result) { ExecuteSearch.call({ search_type: :currencies, cursor: CGI.escape(Base64.strict_encode64('before__Bitcoin')), expires_at: Time.now + 1.day }, :test, stubs) }

        it 'works for cursors that are URI encoded' do
          expect(result[:data]).to eq([{ 'name' => 'Aave', 'symbol' => 'AAVE' }])
        end
      end

      context 'for URI encoded cursors' do
        let(:result) { ExecuteSearch.call({ search_type: :currencies, cursor: Base64.strict_encode64('before__Bitcoin'), expires_at: Time.now + 1.day }, :test, stubs) }

        it 'works for cursors that are not URI encoded' do
          expect(result[:data]).to eq([{ 'name' => 'Aave', 'symbol' => 'AAVE' }])
        end
      end
    end

    context 'sorting pairs' do
      context 'by symbols DESC' do
        let(:result) { ExecuteSearch.call({ search_type: :pairs, symbols: 'AAVE', sort: 'symbols DESC', limit: 3, expires_at: Time.now + 1.day }, :test, stubs) }

        it 'returns the Pairs in the correct order' do
          expect(result[:data]).to eq([{ 'base_currency' => 'Aave',
                                         'quote_currency' => 'United States Dollar',
                                         'status' => 'online',
                                         'symbols' => 'AAVE-USD' },
                                       { 'base_currency' => 'Aave',
                                         'quote_currency' => 'British Pound',
                                         'status' => 'online',
                                         'symbols' => 'AAVE-GBP' },
                                       { 'base_currency' => 'Aave',
                                         'quote_currency' => 'Euro',
                                         'status' => 'online',
                                         'symbols' => 'AAVE-EUR' }])
        end
      end
    end

    context 'getting rates' do
      let(:result) { ExecuteSearch.call({ search_type: :rates, symbols: 'BTC-USD', sort: 'time DESC', limit: 3, expires_at: Time.now + 1.day }, :test, stubs) }

      it 'returns a list of rates' do
        expect(result[:data]).to eq([{ 'close' => '31959.45',
                                       'high' => '31966.53',
                                       'low' => '31911.63',
                                       'open' => '31959.13',
                                       'time' => '2021-01-24T21:54:00.000Z',
                                       'volume' => '19.81926604' },
                                     { 'close' => '31959.82',
                                       'high' => '31964.12',
                                       'low' => '31891.37',
                                       'open' => '31899.99',
                                       'time' => '2021-01-24T21:53:00.000Z',
                                       'volume' => '11.44850635' },
                                     { 'close' => '31900.0',
                                       'high' => '31900.0',
                                       'low' => '31880.01',
                                       'open' => '31898.22',
                                       'time' => '2021-01-24T21:52:00.000Z',
                                       'volume' => '10.08082028' }])
      end
    end
  end
end
