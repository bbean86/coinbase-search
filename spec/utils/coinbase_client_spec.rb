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
          <<~JSON
            [{
                "id": "BTC",
                "name": "Bitcoin",
                "min_size": "0.00000001",
                "status": "online",
                "message": "",
                "max_precision": "0.01",
                "convertible_to": [],
                "details": {
                    "type": "crypto",
                    "symbol": "₿",
                    "network_confirmations": 3,
                    "sort_order": 3,
                    "crypto_address_link": "https://live.blockcypher.com/btc/address/{{address}}",
                    "crypto_transaction_link": "https://live.blockcypher.com/btc/tx/{{txId}}",
                    "push_payment_methods": [
                        "crypto"
                    ],
                    "group_types": [
                        "btc",
                        "crypto"
                    ],
                    "display_name": "",
                    "processing_time_seconds": 0,
                    "min_withdrawal_amount": 0,
                    "max_withdrawal_amount": 1000
                }
            }, {
                "id": "USD",
                "name": "United States Dollar",
                "min_size": "0.01000000",
                "status": "online",
                "message": "",
                "max_precision": "0.01",
                "convertible_to": [
                    "USDC"
                ],
                "details": {
                    "type": "fiat",
                    "symbol": "$",
                    "network_confirmations": 0,
                    "sort_order": 0,
                    "crypto_address_link": "",
                    "crypto_transaction_link": "",
                    "push_payment_methods": [
                        "bank_wire",
                        "fedwire",
                        "swift_bank_account",
                        "intra_bank_account"
                    ],
                    "group_types": [
                        "fiat",
                        "usd"
                    ],
                    "display_name": "US Dollar",
                    "processing_time_seconds": 0,
                    "min_withdrawal_amount": 0
                }
            }]
          JSON
        ]
      end

      expect(client.currencies).to eq([{ name: 'Bitcoin', symbol: 'BTC' }, { name: 'United States Dollar', symbol: 'USD' }])
      stubs.verify_stubbed_calls
    end
  end

  describe '#currency' do
    it 'returns the currency by symbol' do
      stubs.get('/currencies') do
        [
          200,
          { 'Content-Type': 'application/json' },
          <<~JSON
            [{
                "id": "BTC",
                "name": "Bitcoin",
                "min_size": "0.00000001",
                "status": "online",
                "message": "",
                "max_precision": "0.01",
                "convertible_to": [],
                "details": {
                    "type": "crypto",
                    "symbol": "₿",
                    "network_confirmations": 3,
                    "sort_order": 3,
                    "crypto_address_link": "https://live.blockcypher.com/btc/address/{{address}}",
                    "crypto_transaction_link": "https://live.blockcypher.com/btc/tx/{{txId}}",
                    "push_payment_methods": [
                        "crypto"
                    ],
                    "group_types": [
                        "btc",
                        "crypto"
                    ],
                    "display_name": "",
                    "processing_time_seconds": 0,
                    "min_withdrawal_amount": 0,
                    "max_withdrawal_amount": 1000
                }
            }, {
                "id": "USD",
                "name": "United States Dollar",
                "min_size": "0.01000000",
                "status": "online",
                "message": "",
                "max_precision": "0.01",
                "convertible_to": [
                    "USDC"
                ],
                "details": {
                    "type": "fiat",
                    "symbol": "$",
                    "network_confirmations": 0,
                    "sort_order": 0,
                    "crypto_address_link": "",
                    "crypto_transaction_link": "",
                    "push_payment_methods": [
                        "bank_wire",
                        "fedwire",
                        "swift_bank_account",
                        "intra_bank_account"
                    ],
                    "group_types": [
                        "fiat",
                        "usd"
                    ],
                    "display_name": "US Dollar",
                    "processing_time_seconds": 0,
                    "min_withdrawal_amount": 0
                }
            }]
          JSON
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
          <<~JSON
            [
              {
                  "id": "SNX-BTC",
                  "base_currency": "SNX",
                  "quote_currency": "BTC",
                  "base_min_size": "0.10000000",
                  "base_max_size": "19000.00000000",
                  "quote_increment": "0.00000001",
                  "base_increment": "0.01000000",
                  "display_name": "SNX/BTC",
                  "min_market_funds": "0.0001",
                  "max_market_funds": "5.1",
                  "margin_enabled": false,
                  "post_only": false,
                  "limit_only": false,
                  "cancel_only": false,
                  "trading_disabled": false,
                  "status": "online",
                  "status_message": ""
              },
              {
                  "id": "COMP-USD",
                  "base_currency": "COMP",
                  "quote_currency": "USD",
                  "base_min_size": "0.01000000",
                  "base_max_size": "1700.00000000",
                  "quote_increment": "0.01000000",
                  "base_increment": "0.00100000",
                  "display_name": "COMP/USD",
                  "min_market_funds": "1.0",
                  "max_market_funds": "100000",
                  "margin_enabled": false,
                  "post_only": false,
                  "limit_only": false,
                  "cancel_only": false,
                  "trading_disabled": false,
                  "status": "online",
                  "status_message": ""
              },
              {
                  "id": "CGLD-USD",
                  "base_currency": "CGLD",
                  "quote_currency": "USD",
                  "base_min_size": "0.10000000",
                  "base_max_size": "34000.00000000",
                  "quote_increment": "0.00010000",
                  "base_increment": "0.01000000",
                  "display_name": "CGLD/USD",
                  "min_market_funds": "1.0",
                  "max_market_funds": "100000",
                  "margin_enabled": false,
                  "post_only": false,
                  "limit_only": false,
                  "cancel_only": false,
                  "trading_disabled": false,
                  "status": "online",
                  "status_message": ""
              }
            ]
          JSON
        ]
      end

      expect(client.pairs).to eql([
                                    {
                                      base_currency: 'SNX',
                                      quote_currency: 'BTC',
                                      status: 'online',
                                      symbols: 'SNX-BTC'
                                    },
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
                                    }
                                  ])
      stubs.verify_stubbed_calls
    end
  end
end
