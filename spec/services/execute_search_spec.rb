require 'rails_helper'

describe ExecuteSearch do
  describe '.call' do
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }

    before do
      stubs.get('/currencies') do
        [
          200,
          { 'Content-Type': 'application/json' },
          <<~JSON
            [{
                "id": "EUR",
                "name": "Euro",
                "min_size": "0.01",
                "status": "online",
                "message": "",
                "max_precision": "0.01",
                "convertible_to": [],
                "details": {
                    "type": "fiat",
                    "symbol": "€",
                    "network_confirmations": 0,
                    "sort_order": 2,
                    "crypto_address_link": "",
                    "crypto_transaction_link": "",
                    "push_payment_methods": [
                        "sepa_bank_account"
                    ],
                    "group_types": [
                        "fiat",
                        "eur"
                    ],
                    "display_name": "",
                    "processing_time_seconds": 0,
                    "min_withdrawal_amount": 0,
                    "max_withdrawal_amount": 0
                }
            }, {
                "id": "GBP",
                "name": "British Pound",
                "min_size": "0.01",
                "status": "online",
                "message": "",
                "max_precision": "0.01",
                "convertible_to": [],
                "details": {
                    "type": "fiat",
                    "symbol": "£",
                    "network_confirmations": 0,
                    "sort_order": 3,
                    "crypto_address_link": "",
                    "crypto_transaction_link": "",
                    "push_payment_methods": [
                        "uk_bank_account",
                        "swift_lhv",
                        "swift"
                    ],
                    "group_types": [
                        "fiat",
                        "gbp"
                    ],
                    "display_name": "",
                    "processing_time_seconds": 0,
                    "min_withdrawal_amount": 0,
                    "max_withdrawal_amount": 0
                }
            }, {
                "id": "CGLD",
                "name": "Celo",
                "min_size": "0.1",
                "status": "online",
                "message": "",
                "max_precision": "0.01",
                "convertible_to": [],
                "details": {
                    "type": "crypto",
                    "symbol": "",
                    "network_confirmations": 4,
                    "sort_order": 200,
                    "crypto_address_link": "https://explorer.celo.org/address/{{address}}",
                    "crypto_transaction_link": "https://explorer.celo.org/tx/{{txId}}/token_transfers",
                    "push_payment_methods": [
                        "crypto"
                    ],
                    "group_types": [],
                    "display_name": "",
                    "processing_time_seconds": 0,
                    "min_withdrawal_amount": 0.1,
                    "max_withdrawal_amount": 250000
                }
            }, {
                "id": "COMP",
                "name": "Compound",
                "min_size": "0.01",
                "status": "online",
                "message": "",
                "max_precision": "0.001",
                "convertible_to": [],
                "details": {
                    "type": "crypto",
                    "symbol": "",
                    "network_confirmations": 35,
                    "sort_order": 140,
                    "crypto_address_link": "https://etherscan.io/token/0xc00e94cb662c3520282e6f5717214004a7f26888?a={{address}}",
                    "crypto_transaction_link": "https://etherscan.io/tx/0x{{txId}}",
                    "push_payment_methods": [
                        "crypto"
                    ],
                    "group_types": [],
                    "display_name": "",
                    "processing_time_seconds": 0,
                    "min_withdrawal_amount": 0.01,
                    "max_withdrawal_amount": 20000
                }
            }, {
                "id": "AAVE",
                "name": "Aave",
                "min_size": "0.01",
                "status": "online",
                "message": "",
                "max_precision": "0.001",
                "convertible_to": [],
                "details": {
                    "type": "crypto",
                    "symbol": "",
                    "network_confirmations": 35,
                    "sort_order": 270,
                    "crypto_address_link": "https://etherscan.io/token/0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9?a={{address}}",
                    "crypto_transaction_link": "https://etherscan.io/tx/0x{{txId}}",
                    "push_payment_methods": [
                        "crypto"
                    ],
                    "group_types": [],
                    "display_name": "",
                    "processing_time_seconds": 0,
                    "min_withdrawal_amount": 0.07,
                    "max_withdrawal_amount": 5000
                }
            }, {
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
            }, {
                "id": "WBTC",
                "name": "Wrapped Bitcoin",
                "min_size": "0.0001",
                "status": "online",
                "message": "",
                "max_precision": "0.00000001",
                "convertible_to": [],
                "details": {
                    "type": "crypto",
                    "symbol": "",
                    "network_confirmations": 35,
                    "sort_order": 230,
                    "crypto_address_link": "https://etherscan.io/token/0x2260fac5e5542a773aa44fbcfedf7c193bc2c599?a={{address}}",
                    "crypto_transaction_link": "https://etherscan.io/tx/0x{{txId}}",
                    "push_payment_methods": [
                        "crypto"
                    ],
                    "group_types": [],
                    "display_name": "",
                    "processing_time_seconds": 0,
                    "min_withdrawal_amount": 0.00054,
                    "max_withdrawal_amount": 62.5
                }
            }, {
                "id": "BCH",
                "name": "Bitcoin Cash",
                "min_size": "0.00000001",
                "status": "online",
                "message": "",
                "max_precision": "0.00000001",
                "convertible_to": [],
                "details": {
                    "type": "crypto",
                    "symbol": "₿",
                    "network_confirmations": 12,
                    "sort_order": 40,
                    "crypto_address_link": "https://blockchair.com/bitcoin-cash/address/{{address}}",
                    "crypto_transaction_link": "https://blockchair.com/bitcoin-cash/transaction/{{txId}}",
                    "push_payment_methods": [
                        "crypto"
                    ],
                    "group_types": [],
                    "display_name": "",
                    "processing_time_seconds": 0,
                    "min_withdrawal_amount": 0.00001,
                    "max_withdrawal_amount": 8500
                }
            }]
          JSON
        ]
      end

      stubs.get('/products') do
        [
          200,
          { 'Content-Type' => 'application/json' },
          <<~JSON
            [
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
              },
              {
                  "id": "AAVE-BTC",
                  "base_currency": "AAVE",
                  "quote_currency": "BTC",
                  "base_min_size": "0.01000000",
                  "base_max_size": "1200.00000000",
                  "quote_increment": "0.00000001",
                  "base_increment": "0.00100000",
                  "display_name": "AAVE/BTC",
                  "min_market_funds": "0.0001",
                  "max_market_funds": "5.2",
                  "margin_enabled": false,
                  "post_only": false,
                  "limit_only": false,
                  "cancel_only": false,
                  "trading_disabled": false,
                  "status": "online",
                  "status_message": ""
              },
              {
                  "id": "AAVE-GBP",
                  "base_currency": "AAVE",
                  "quote_currency": "GBP",
                  "base_min_size": "0.01000000",
                  "base_max_size": "1200.00000000",
                  "quote_increment": "0.00100000",
                  "base_increment": "0.00100000",
                  "display_name": "AAVE/GBP",
                  "min_market_funds": "1.0",
                  "max_market_funds": "82000",
                  "margin_enabled": false,
                  "post_only": false,
                  "limit_only": true,
                  "cancel_only": false,
                  "trading_disabled": false,
                  "status": "online",
                  "status_message": ""
              },
              {
                  "id": "AAVE-USD",
                  "base_currency": "AAVE",
                  "quote_currency": "USD",
                  "base_min_size": "0.01000000",
                  "base_max_size": "1200.00000000",
                  "quote_increment": "0.00100000",
                  "base_increment": "0.00100000",
                  "display_name": "AAVE/USD",
                  "min_market_funds": "1.0",
                  "max_market_funds": "500000",
                  "margin_enabled": false,
                  "post_only": false,
                  "limit_only": false,
                  "cancel_only": false,
                  "trading_disabled": false,
                  "status": "online",
                  "status_message": ""
              },
              {
                  "id": "AAVE-EUR",
                  "base_currency": "AAVE",
                  "quote_currency": "EUR",
                  "base_min_size": "0.01000000",
                  "base_max_size": "1200.00000000",
                  "quote_increment": "0.00100000",
                  "base_increment": "0.00100000",
                  "display_name": "AAVE/EUR",
                  "min_market_funds": "1.0",
                  "max_market_funds": "92000",
                  "margin_enabled": false,
                  "post_only": false,
                  "limit_only": true,
                  "cancel_only": false,
                  "trading_disabled": false,
                  "status": "online",
                  "status_message": ""
              }
            ]
          JSON
        ]
      end
    end

    it 'finds an existing Search by the given search_type and query params' do
      Search.create search_type: 'currencies',
                    query_params: { name: 'Bit' },
                    result: [{ name: 'Bitcon', symbol: 'BTC' }],
                    expires_at: Time.now + 1.hour

      result = ExecuteSearch.call({ search_type: :currencies, name: 'Bit' }, :test, stubs)

      expect(result[:data]).to_not be_empty
    end

    context 'sorting currencies by name DESC' do
      it 'returns the Currencies in the correct order' do
        result = ExecuteSearch.call({ search_type: :currencies, name: 'Bit', sort: 'name DESC' }, :test, stubs)

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

    context 'sorting pairs' do
      context 'by symbols DESC' do
        it 'returns the Pairs in the correct order' do
          result = ExecuteSearch.call({ search_type: :pairs, symbols: 'AAVE', sort: 'symbols DESC', limit: 3 }, :test, stubs)

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
  end
end
