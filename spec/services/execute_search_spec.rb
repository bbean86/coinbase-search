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

      stubs.get('/products/BTC-USD') do
        [
          200,
          { 'Content-Type' => 'application/json' },
          <<~JSON
            {
                "id": "BTC-USD",
                "base_currency": "BTC",
                "quote_currency": "USD",
                "base_min_size": "0.00100000",
                "base_max_size": "280.00000000",
                "quote_increment": "0.01000000",
                "base_increment": "0.00000001",
                "display_name": "BTC/USD",
                "min_market_funds": "5",
                "max_market_funds": "1000000",
                "margin_enabled": false,
                "post_only": false,
                "limit_only": false,
                "cancel_only": false,
                "trading_disabled": false,
                "status": "online",
                "status_message": ""
            }
          JSON
        ]
      end

      stubs.get('/products/BTC-USD/candles') do
        [
          200,
          { 'Content-Type' => 'application/json' },
          <<~JSON
                      [
                [
                    1611525240,
                    31911.63,
                    31966.53,
                    31959.13,
                    31959.45,
                    19.81926604
                ],
                [
                    1611525180,
                    31891.37,
                    31964.12,
                    31899.99,
                    31959.82,
                    11.44850635
                ],
                [
                    1611525120,
                    31880.01,
                    31900,
                    31898.22,
                    31900,
                    10.08082028
                ],
                [
                    1611525060,
                    31842.2,
                    31898.22,
                    31850.65,
                    31898.22,
                    20.83321757
                ],
                [
                    1611525000,
                    31790.39,
                    31852.23,
                    31798.04,
                    31852.23,
                    5.28232863
                ],
                [
                    1611524940,
                    31743.87,
                    31798.04,
                    31765.13,
                    31798.03,
                    6.1376732
                ],
                [
                    1611524880,
                    31716.28,
                    31767.13,
                    31729.56,
                    31766.31,
                    3.37216808
                ],
                [
                    1611524820,
                    31690.55,
                    31738.65,
                    31724.99,
                    31730.2,
                    23.16417574
                ],
                [
                    1611524760,
                    31724.99,
                    31778.6,
                    31778.6,
                    31731.49,
                    20.38993338
                ],
                [
                    1611524700,
                    31739.77,
                    31789.09,
                    31739.78,
                    31778.6,
                    7.64089684
                ],
                [
                    1611524640,
                    31736.8,
                    31769.74,
                    31736.8,
                    31743.04,
                    6.69218146
                ],
                [
                    1611524580,
                    31721.77,
                    31740.72,
                    31734.32,
                    31736.8,
                    12.00515428
                ],
                [
                    1611524520,
                    31733.28,
                    31758.58,
                    31758.58,
                    31740.46,
                    6.09461998
                ],
                [
                    1611524460,
                    31750,
                    31788.16,
                    31788.16,
                    31758.58,
                    2.39336218
                ],
                [
                    1611524400,
                    31778.34,
                    31801.63,
                    31794.36,
                    31789.17,
                    9.59966332
                ],
                [
                    1611524340,
                    31759.28,
                    31799.83,
                    31763.59,
                    31794.37,
                    1.72773768
                ],
                [
                    1611524280,
                    31733.41,
                    31765.24,
                    31740.01,
                    31760.25,
                    10.18406229
                ],
                [
                    1611524220,
                    31740,
                    31789.87,
                    31755.96,
                    31740,
                    13.6018409
                ],
                [
                    1611524160,
                    31736.11,
                    31770.23,
                    31770.23,
                    31755.95,
                    2.45943136
                ],
                [
                    1611524100,
                    31741.98,
                    31773.1,
                    31760.63,
                    31769.47,
                    3.67141725
                ],
                [
                    1611524040,
                    31757.3,
                    31789.3,
                    31765.77,
                    31760.63,
                    3.71760485
                ],
                [
                    1611523980,
                    31747.67,
                    31770.93,
                    31770.93,
                    31766.61,
                    4.49861342
                ],
                [
                    1611523920,
                    31757.29,
                    31789.03,
                    31789.03,
                    31774.04,
                    13.3989041
                ],
                [
                    1611523860,
                    31714.33,
                    31796.95,
                    31714.33,
                    31789.03,
                    10.08127516
                ],
                [
                    1611523800,
                    31711.61,
                    31744.32,
                    31744.32,
                    31714.33,
                    3.15841412
                ],
                [
                    1611523740,
                    31725.6,
                    31752.48,
                    31729.82,
                    31748.76,
                    2.27451651
                ],
                [
                    1611523680,
                    31729.82,
                    31750.18,
                    31745.87,
                    31729.82,
                    5.85797695
                ],
                [
                    1611523620,
                    31742.69,
                    31751.65,
                    31744.18,
                    31745.87,
                    1.00013719
                ],
                [
                    1611523560,
                    31740.19,
                    31775.04,
                    31774.48,
                    31746.17,
                    2.91742461
                ],
                [
                    1611523500,
                    31765.6,
                    31793.87,
                    31793.73,
                    31773.85,
                    3.41036704
                ],
                [
                    1611523440,
                    31734.04,
                    31791.95,
                    31761.34,
                    31791.95,
                    16.42676824
                ],
                [
                    1611523380,
                    31755.88,
                    31818.17,
                    31767.02,
                    31757.03,
                    12.2682928
                ],
                [
                    1611523320,
                    31760.49,
                    31825.2,
                    31823.32,
                    31760.49,
                    6.9443348
                ],
                [
                    1611523260,
                    31800.01,
                    31836.46,
                    31800.01,
                    31825.21,
                    3.84972408
                ],
                [
                    1611523200,
                    31749.55,
                    31835.69,
                    31749.56,
                    31800.02,
                    11.37751415
                ],
                [
                    1611523140,
                    31747.17,
                    31769.84,
                    31754.87,
                    31759.48,
                    4.12307615
                ],
                [
                    1611523080,
                    31681.45,
                    31750.8,
                    31692.23,
                    31750.8,
                    9.34400605
                ],
                [
                    1611523020,
                    31623.23,
                    31696.72,
                    31623.23,
                    31689.3,
                    4.90732882
                ],
                [
                    1611522960,
                    31605.31,
                    31687.66,
                    31685.17,
                    31624.13,
                    9.00381685
                ],
                [
                    1611522900,
                    31685.16,
                    31758.4,
                    31701.47,
                    31685.17,
                    7.94570146
                ],
                [
                    1611522840,
                    31689.33,
                    31701.46,
                    31692.59,
                    31699.33,
                    6.21230412
                ],
                [
                    1611522780,
                    31650,
                    31694.11,
                    31668.64,
                    31692.59,
                    1.89911945
                ],
                [
                    1611522720,
                    31628.52,
                    31671.23,
                    31635.96,
                    31659.65,
                    1.52902887
                ],
                [
                    1611522660,
                    31631.73,
                    31672.49,
                    31670.13,
                    31634.45,
                    8.60333631
                ],
                [
                    1611522600,
                    31670.01,
                    31713,
                    31699.99,
                    31676.49,
                    14.95243784
                ],
                [
                    1611522540,
                    31677.39,
                    31706.69,
                    31684.75,
                    31699.95,
                    4.60721121
                ],
                [
                    1611522480,
                    31640.62,
                    31678.93,
                    31654.02,
                    31678.93,
                    5.09058312
                ],
                [
                    1611522420,
                    31640.62,
                    31714.01,
                    31703.2,
                    31648.61,
                    18.95136017
                ],
                [
                    1611522360,
                    31666.61,
                    31713.45,
                    31666.62,
                    31707.9,
                    15.6771323
                ],
                [
                    1611522300,
                    31652.93,
                    31678.73,
                    31671.92,
                    31666.62,
                    12.016457
                ],
                [
                    1611522240,
                    31657.3,
                    31704.18,
                    31692.58,
                    31671.92,
                    4.42474062
                ],
                [
                    1611522180,
                    31640.16,
                    31700,
                    31660.6,
                    31692.58,
                    4.47428819
                ],
                [
                    1611522120,
                    31626.2,
                    31671.92,
                    31643.14,
                    31660.62,
                    3.62679777
                ],
                [
                    1611522060,
                    31621.94,
                    31645.85,
                    31645.85,
                    31639.63,
                    7.24058216
                ],
                [
                    1611522000,
                    31643.52,
                    31700.85,
                    31700.14,
                    31648.21,
                    3.72207686
                ],
                [
                    1611521940,
                    31667.91,
                    31709.54,
                    31672.73,
                    31697.78,
                    7.39126637
                ],
                [
                    1611521880,
                    31647.43,
                    31684.17,
                    31684.17,
                    31671.33,
                    7.33124687
                ],
                [
                    1611521820,
                    31619.84,
                    31700,
                    31619.85,
                    31690.23,
                    6.12591672
                ],
                [
                    1611521760,
                    31599.41,
                    31626.67,
                    31626.67,
                    31616.28,
                    2.7557134
                ],
                [
                    1611521700,
                    31581.36,
                    31628.06,
                    31594.92,
                    31624.99,
                    9.7403174
                ],
                [
                    1611521640,
                    31600,
                    31645.35,
                    31620.98,
                    31600,
                    3.14191483
                ],
                [
                    1611521580,
                    31618.93,
                    31650,
                    31634.59,
                    31621,
                    3.73404205
                ],
                [
                    1611521520,
                    31602.78,
                    31700.5,
                    31635.38,
                    31648.18,
                    37.78715248
                ],
                [
                    1611521460,
                    31633.8,
                    31663.14,
                    31646.56,
                    31644.66,
                    4.09889763
                ],
                [
                    1611521400,
                    31609.5,
                    31684.91,
                    31609.5,
                    31651.08,
                    3.2433856
                ],
                [
                    1611521340,
                    31608.67,
                    31659.29,
                    31654.42,
                    31608.67,
                    5.02836397
                ],
                [
                    1611521280,
                    31649.78,
                    31709.53,
                    31651.51,
                    31649.78,
                    9.64506153
                ],
                [
                    1611521220,
                    31629.11,
                    31676.54,
                    31629.11,
                    31651.52,
                    9.23038346
                ],
                [
                    1611521160,
                    31626.74,
                    31685.14,
                    31650.19,
                    31626.74,
                    14.30902604
                ],
                [
                    1611521100,
                    31650,
                    31713.98,
                    31713.98,
                    31650.19,
                    15.16728314
                ],
                [
                    1611521040,
                    31685.26,
                    31736.8,
                    31686.82,
                    31708.3,
                    48.30504074
                ],
                [
                    1611520980,
                    31678.84,
                    31720.24,
                    31678.88,
                    31685.39,
                    19.30958791
                ],
                [
                    1611520920,
                    31678.74,
                    31750.56,
                    31726.07,
                    31682.04,
                    11.13062796
                ],
                [
                    1611520860,
                    31633.42,
                    31775.65,
                    31645.7,
                    31725.6,
                    34.46091339
                ],
                [
                    1611520800,
                    31613.8,
                    31656.28,
                    31618.2,
                    31648.76,
                    8.9804225
                ],
                [
                    1611520740,
                    31607.87,
                    31646.03,
                    31646.01,
                    31626.85,
                    8.50136293
                ],
                [
                    1611520680,
                    31607,
                    31700.27,
                    31699.86,
                    31639.01,
                    17.28313474
                ],
                [
                    1611520620,
                    31537.99,
                    31700,
                    31538.82,
                    31697.03,
                    20.39803297
                ],
                [
                    1611520560,
                    31526.78,
                    31550,
                    31543.28,
                    31538.81,
                    5.73987994
                ],
                [
                    1611520500,
                    31520.01,
                    31568.08,
                    31520.01,
                    31543.47,
                    10.35357624
                ],
                [
                    1611520440,
                    31517.24,
                    31544,
                    31524.51,
                    31522.57,
                    6.20041716
                ],
                [
                    1611520380,
                    31508.7,
                    31548.68,
                    31544.87,
                    31524.99,
                    6.25964617
                ],
                [
                    1611520320,
                    31491.36,
                    31565,
                    31491.36,
                    31542.86,
                    11.21434496
                ],
                [
                    1611520260,
                    31480.62,
                    31512.89,
                    31488.64,
                    31491.37,
                    12.1393734
                ],
                [
                    1611520200,
                    31460.16,
                    31514.59,
                    31463.79,
                    31494.32,
                    8.76068454
                ],
                [
                    1611520140,
                    31461.79,
                    31523.39,
                    31512.31,
                    31469.48,
                    11.99487805
                ],
                [
                    1611520080,
                    31429.19,
                    31514.69,
                    31429.19,
                    31506.19,
                    51.10116846
                ],
                [
                    1611520020,
                    31433.54,
                    31484.3,
                    31461.48,
                    31433.54,
                    11.36409693
                ],
                [
                    1611519960,
                    31454.89,
                    31509.68,
                    31504.92,
                    31461.48,
                    5.55378932
                ],
                [
                    1611519900,
                    31500,
                    31516.56,
                    31510,
                    31502.31,
                    10.26503536
                ],
                [
                    1611519840,
                    31482.11,
                    31510,
                    31506.25,
                    31510,
                    21.08669286
                ],
                [
                    1611519780,
                    31409.41,
                    31515.83,
                    31409.41,
                    31506.25,
                    13.28049486
                ],
                [
                    1611519720,
                    31361.51,
                    31415.39,
                    31363.23,
                    31410.3,
                    5.89187039
                ],
                [
                    1611519660,
                    31360.62,
                    31425.07,
                    31415.78,
                    31371.71,
                    21.29226574
                ],
                [
                    1611519600,
                    31376.47,
                    31423.13,
                    31408.43,
                    31415.78,
                    4.09339207
                ],
                [
                    1611519540,
                    31310.76,
                    31425.13,
                    31334.36,
                    31410.29,
                    13.21238869
                ],
                [
                    1611519480,
                    31324.18,
                    31368.49,
                    31338.48,
                    31338.07,
                    6.4209978
                ],
                [
                    1611519420,
                    31332.98,
                    31400,
                    31399.95,
                    31336.55,
                    4.24558327
                ],
                [
                    1611519360,
                    31333.98,
                    31400,
                    31341.3,
                    31399.99,
                    8.64855516
                ],
                [
                    1611519300,
                    31340,
                    31393.47,
                    31391.71,
                    31340.01,
                    12.39030757
                ],
                [
                    1611519240,
                    31378.34,
                    31430.5,
                    31417.68,
                    31393.47,
                    5.77857476
                ],
                [
                    1611519180,
                    31389.43,
                    31431.43,
                    31399.13,
                    31421,
                    5.58356873
                ],
                [
                    1611519120,
                    31347.16,
                    31399.98,
                    31347.21,
                    31399.13,
                    9.14793987
                ],
                [
                    1611519060,
                    31340,
                    31372.31,
                    31372.31,
                    31351.94,
                    7.9758589
                ],
                [
                    1611519000,
                    31342.49,
                    31389.76,
                    31342.49,
                    31372.31,
                    9.80571175
                ],
                [
                    1611518940,
                    31339.88,
                    31376.6,
                    31375.07,
                    31342.49,
                    4.21459624
                ],
                [
                    1611518880,
                    31355,
                    31380.73,
                    31379.87,
                    31374.09,
                    6.71284081
                ],
                [
                    1611518820,
                    31374.91,
                    31390.92,
                    31390.49,
                    31383.54,
                    7.16478792
                ],
                [
                    1611518760,
                    31350.02,
                    31415.5,
                    31350.02,
                    31390.49,
                    10.27737995
                ],
                [
                    1611518700,
                    31332.95,
                    31374.06,
                    31371.39,
                    31335.07,
                    8.35318062
                ],
                [
                    1611518640,
                    31371.97,
                    31442.18,
                    31395.71,
                    31372.34,
                    9.31032397
                ],
                [
                    1611518580,
                    31364.65,
                    31430.15,
                    31430.15,
                    31393.13,
                    24.41432802
                ],
                [
                    1611518520,
                    31408.4,
                    31514.34,
                    31430,
                    31435.83,
                    46.93248056
                ],
                [
                    1611518460,
                    31292.91,
                    31430,
                    31294.88,
                    31430,
                    28.49884298
                ],
                [
                    1611518400,
                    31279.33,
                    31340.15,
                    31340.15,
                    31293.58,
                    14.77637194
                ],
                [
                    1611518340,
                    31308.62,
                    31388.43,
                    31361.41,
                    31340.22,
                    23.70531447
                ],
                [
                    1611518280,
                    31319.88,
                    31365.03,
                    31320,
                    31361.42,
                    5.32724328
                ],
                [
                    1611518220,
                    31320.42,
                    31339.07,
                    31329.35,
                    31323.53,
                    32.49762223
                ],
                [
                    1611518160,
                    31284.42,
                    31357.69,
                    31284.42,
                    31330,
                    30.47055154
                ],
                [
                    1611518100,
                    31277.81,
                    31296.24,
                    31296.24,
                    31284.04,
                    9.2671048
                ],
                [
                    1611518040,
                    31269.7,
                    31296.24,
                    31280.56,
                    31296.24,
                    9.76151921
                ],
                [
                    1611517980,
                    31270.06,
                    31294.08,
                    31290.37,
                    31279.71,
                    15.55859821
                ],
                [
                    1611517920,
                    31271.13,
                    31326.09,
                    31273.62,
                    31293.72,
                    19.23461493
                ],
                [
                    1611517860,
                    31261.81,
                    31299.66,
                    31299.66,
                    31281.56,
                    7.32087841
                ],
                [
                    1611517800,
                    31232.13,
                    31299.66,
                    31271.05,
                    31299.65,
                    8.21452384
                ],
                [
                    1611517740,
                    31265.7,
                    31368.31,
                    31354.9,
                    31271.05,
                    20.26407346
                ],
                [
                    1611517680,
                    31286.31,
                    31368.99,
                    31286.31,
                    31354.28,
                    12.89181245
                ],
                [
                    1611517620,
                    31266.05,
                    31317.44,
                    31290.15,
                    31287.78,
                    12.0703544
                ],
                [
                    1611517560,
                    31278.98,
                    31321.81,
                    31305.81,
                    31300.43,
                    10.05271629
                ],
                [
                    1611517500,
                    31205.17,
                    31319.41,
                    31230,
                    31317.07,
                    18.33949813
                ],
                [
                    1611517440,
                    31178.08,
                    31239.99,
                    31180,
                    31230,
                    19.42488758
                ],
                [
                    1611517380,
                    31171.41,
                    31204.82,
                    31200,
                    31180,
                    8.10446861
                ],
                [
                    1611517320,
                    31179.41,
                    31240,
                    31197.07,
                    31186.65,
                    13.8300998
                ],
                [
                    1611517260,
                    31162.49,
                    31241.82,
                    31180.27,
                    31199.27,
                    17.86813426
                ],
                [
                    1611517200,
                    31147.27,
                    31241.83,
                    31174.48,
                    31180.26,
                    22.83986189
                ],
                [
                    1611517140,
                    31144.02,
                    31221.2,
                    31190.01,
                    31168.78,
                    11.33805018
                ],
                [
                    1611517080,
                    31190,
                    31277.37,
                    31223.75,
                    31190,
                    16.65613786
                ],
                [
                    1611517020,
                    31200.07,
                    31267.28,
                    31267.09,
                    31220.76,
                    23.42507587
                ],
                [
                    1611516960,
                    31261,
                    31322.01,
                    31305.08,
                    31267.1,
                    12.53882894
                ],
                [
                    1611516900,
                    31216.68,
                    31324.69,
                    31216.89,
                    31308.93,
                    30.00791147
                ],
                [
                    1611516840,
                    31100.72,
                    31221.45,
                    31132.17,
                    31212.71,
                    50.2240719
                ],
                [
                    1611516780,
                    31015.42,
                    31146.53,
                    31016.79,
                    31136.13,
                    15.54718299
                ],
                [
                    1611516720,
                    30965.05,
                    31080,
                    30996.88,
                    31017.7,
                    48.22768875
                ],
                [
                    1611516660,
                    30931.21,
                    31079.02,
                    31032.3,
                    30996.88,
                    131.24823527
                ],
                [
                    1611516600,
                    31000,
                    31183.37,
                    31183.37,
                    31024.2,
                    156.0824111
                ],
                [
                    1611516540,
                    31127.47,
                    31187.62,
                    31162.21,
                    31183.36,
                    73.35563867
                ],
                [
                    1611516480,
                    31120.02,
                    31225.06,
                    31221.06,
                    31163.08,
                    42.86099058
                ],
                [
                    1611516420,
                    31215.67,
                    31257.82,
                    31257.55,
                    31219.15,
                    18.56251631
                ],
                [
                    1611516360,
                    31251.49,
                    31277.38,
                    31276.09,
                    31257.49,
                    5.99515507
                ],
                [
                    1611516300,
                    31227.26,
                    31284.45,
                    31278.09,
                    31275.73,
                    9.41153288
                ],
                [
                    1611516240,
                    31225.97,
                    31310,
                    31310,
                    31278.28,
                    26.22728368
                ],
                [
                    1611516180,
                    31298.81,
                    31326.8,
                    31298.93,
                    31310,
                    20.98597446
                ],
                [
                    1611516120,
                    31256.56,
                    31310.23,
                    31261.94,
                    31299.3,
                    22.78600647
                ],
                [
                    1611516060,
                    31193.8,
                    31280.54,
                    31208.48,
                    31261.92,
                    38.65206354
                ],
                [
                    1611516000,
                    31155.34,
                    31277.93,
                    31225.81,
                    31202.5,
                    55.72167343
                ],
                [
                    1611515940,
                    31225.42,
                    31300.01,
                    31300.01,
                    31227.46,
                    23.70623513
                ],
                [
                    1611515880,
                    31294.66,
                    31331.66,
                    31322.26,
                    31300.01,
                    24.24614105
                ],
                [
                    1611515820,
                    31232.47,
                    31348.77,
                    31232.47,
                    31323,
                    38.56301853
                ],
                [
                    1611515760,
                    31228.32,
                    31355.95,
                    31328.3,
                    31235.47,
                    35.84303515
                ],
                [
                    1611515700,
                    31222.22,
                    31511.09,
                    31500.01,
                    31339.63,
                    171.66951179
                ],
                [
                    1611515640,
                    31459.85,
                    31530.06,
                    31462.25,
                    31500.01,
                    62.75034826
                ],
                [
                    1611515580,
                    31462,
                    31698.33,
                    31679.72,
                    31465.74,
                    134.89960073
                ],
                [
                    1611515520,
                    31636.73,
                    31695.19,
                    31686.8,
                    31679.73,
                    44.72457716
                ],
                [
                    1611515460,
                    31675.8,
                    31707.93,
                    31707.07,
                    31686.26,
                    15.45511722
                ],
                [
                    1611515400,
                    31700,
                    31783.36,
                    31783.14,
                    31707.06,
                    25.27728497
                ],
                [
                    1611515340,
                    31779.76,
                    31825.58,
                    31823.2,
                    31783.15,
                    11.64377707
                ],
                [
                    1611515280,
                    31820.81,
                    31851.94,
                    31845.11,
                    31825.18,
                    2.85897254
                ],
                [
                    1611515220,
                    31842.81,
                    31869.34,
                    31865.31,
                    31845.1,
                    7.19044119
                ],
                [
                    1611515160,
                    31829,
                    31865.31,
                    31829.91,
                    31865.31,
                    17.05658125
                ],
                [
                    1611515100,
                    31825.25,
                    31860,
                    31843.87,
                    31829.01,
                    6.96685108
                ],
                [
                    1611515040,
                    31838.94,
                    31871.22,
                    31843.27,
                    31843.87,
                    2.9947144
                ],
                [
                    1611514980,
                    31813.78,
                    31846.61,
                    31820.5,
                    31834.1,
                    2.97539646
                ],
                [
                    1611514920,
                    31809,
                    31828.73,
                    31819.14,
                    31816.41,
                    3.44640507
                ],
                [
                    1611514860,
                    31770,
                    31836.63,
                    31801,
                    31836.63,
                    13.76676673
                ],
                [
                    1611514800,
                    31801,
                    31871.79,
                    31871.79,
                    31801.01,
                    8.93600423
                ],
                [
                    1611514740,
                    31854.99,
                    31871.79,
                    31861.61,
                    31871.79,
                    1.97053452
                ],
                [
                    1611514680,
                    31850,
                    31879.65,
                    31877.81,
                    31861.7,
                    5.9613291
                ],
                [
                    1611514620,
                    31875.25,
                    31926.81,
                    31926.81,
                    31878.28,
                    3.46694414
                ],
                [
                    1611514560,
                    31921.59,
                    31950.34,
                    31925.09,
                    31930.64,
                    5.59941816
                ],
                [
                    1611514500,
                    31899.9,
                    31925.09,
                    31900.01,
                    31925.09,
                    6.91336603
                ],
                [
                    1611514440,
                    31900,
                    31940.89,
                    31925.87,
                    31901.88,
                    5.51729743
                ],
                [
                    1611514380,
                    31922.51,
                    31947,
                    31922.51,
                    31925.88,
                    9.13668627
                ],
                [
                    1611514320,
                    31900.48,
                    31933.12,
                    31933.11,
                    31920.95,
                    4.7912802
                ],
                [
                    1611514260,
                    31927.47,
                    31933.52,
                    31932.08,
                    31933.12,
                    2.98449557
                ],
                [
                    1611514200,
                    31914.82,
                    31944.23,
                    31919.69,
                    31932.44,
                    2.89343192
                ],
                [
                    1611514140,
                    31907.82,
                    31968.01,
                    31968.01,
                    31919.69,
                    4.98093469
                ],
                [
                    1611514080,
                    31937.17,
                    31970.77,
                    31948.4,
                    31968.01,
                    6.02975384
                ],
                [
                    1611514020,
                    31895,
                    31948.41,
                    31895.01,
                    31948.4,
                    15.66595237
                ],
                [
                    1611513960,
                    31870,
                    31895.01,
                    31888.61,
                    31895.01,
                    2.35749519
                ],
                [
                    1611513900,
                    31870.83,
                    31903.71,
                    31903.71,
                    31894.31,
                    3.64709367
                ],
                [
                    1611513840,
                    31888.47,
                    31903.71,
                    31888.85,
                    31903.7,
                    6.4551874
                ],
                [
                    1611513780,
                    31875.38,
                    31903.34,
                    31880.28,
                    31883,
                    3.66755181
                ],
                [
                    1611513720,
                    31869.14,
                    31901.74,
                    31869.14,
                    31880.28,
                    4.12051767
                ],
                [
                    1611513660,
                    31854.4,
                    31870,
                    31855.1,
                    31866.99,
                    7.64445741
                ],
                [
                    1611513600,
                    31835,
                    31856.99,
                    31838.91,
                    31855.1,
                    9.11764692
                ],
                [
                    1611513540,
                    31820.63,
                    31847.51,
                    31841.93,
                    31840,
                    6.60722931
                ],
                [
                    1611513480,
                    31826.08,
                    31850,
                    31850,
                    31845.22,
                    5.88608808
                ],
                [
                    1611513420,
                    31820,
                    31869.02,
                    31869.02,
                    31850,
                    8.89644178
                ],
                [
                    1611513360,
                    31858.33,
                    31869.4,
                    31860.05,
                    31865.09,
                    2.80743467
                ],
                [
                    1611513300,
                    31843.39,
                    31882.95,
                    31843.39,
                    31866.83,
                    8.38581223
                ],
                [
                    1611513240,
                    31838.05,
                    31848.59,
                    31845.38,
                    31843.39,
                    2.04542656
                ],
                [
                    1611513180,
                    31821,
                    31851.36,
                    31840.01,
                    31851.36,
                    3.40503371
                ],
                [
                    1611513120,
                    31840,
                    31896.58,
                    31879.84,
                    31840.01,
                    2.58534743
                ],
                [
                    1611513060,
                    31858.09,
                    31898.05,
                    31858.09,
                    31877.99,
                    20.35298502
                ],
                [
                    1611513000,
                    31832.58,
                    31864,
                    31832.58,
                    31858.1,
                    7.13080376
                ],
                [
                    1611512940,
                    31832.58,
                    31864,
                    31855.91,
                    31832.58,
                    6.71366557
                ],
                [
                    1611512880,
                    31836.29,
                    31862.08,
                    31849.84,
                    31856.69,
                    2.68639992
                ],
                [
                    1611512820,
                    31830.21,
                    31858,
                    31830.21,
                    31849.84,
                    3.2922618
                ],
                [
                    1611512760,
                    31826.21,
                    31860.48,
                    31851.71,
                    31831.22,
                    10.97150088
                ],
                [
                    1611512700,
                    31840,
                    31871.05,
                    31849.64,
                    31851.72,
                    5.33917685
                ],
                [
                    1611512640,
                    31846.07,
                    31884.18,
                    31882.97,
                    31849.65,
                    4.52577067
                ],
                [
                    1611512580,
                    31851.7,
                    31888.48,
                    31861.38,
                    31883.16,
                    5.01225314
                ],
                [
                    1611512520,
                    31860,
                    31890,
                    31890,
                    31861.37,
                    5.882275
                ],
                [
                    1611512460,
                    31888.97,
                    31919.46,
                    31919.45,
                    31890.01,
                    5.52016581
                ],
                [
                    1611512400,
                    31900.83,
                    31922.26,
                    31900.83,
                    31919.46,
                    7.1342773
                ],
                [
                    1611512340,
                    31900.83,
                    31960.01,
                    31960.01,
                    31900.83,
                    10.16452598
                ],
                [
                    1611512280,
                    31943.56,
                    31963.22,
                    31961.28,
                    31961.29,
                    5.40419627
                ],
                [
                    1611512220,
                    31944.49,
                    31971.49,
                    31971.49,
                    31961.27,
                    3.11964892
                ],
                [
                    1611512160,
                    31930.39,
                    31974.3,
                    31948.79,
                    31968.36,
                    12.78438631
                ],
                [
                    1611512100,
                    31889.23,
                    31948.79,
                    31922.94,
                    31948.79,
                    6.28509601
                ],
                [
                    1611512040,
                    31906.45,
                    31924.35,
                    31912.01,
                    31922.94,
                    4.70366068
                ],
                [
                    1611511980,
                    31880.75,
                    31918.32,
                    31880.76,
                    31912.01,
                    7.0742564
                ],
                [
                    1611511920,
                    31858.8,
                    31895.44,
                    31895.44,
                    31880.76,
                    6.67937584
                ],
                [
                    1611511860,
                    31850.54,
                    31903.82,
                    31881.54,
                    31895.48,
                    3.19256396
                ],
                [
                    1611511800,
                    31852.21,
                    31907.04,
                    31903.79,
                    31877.67,
                    16.32483975
                ],
                [
                    1611511740,
                    31881.39,
                    31932.31,
                    31881.39,
                    31903.79,
                    4.25336407
                ],
                [
                    1611511680,
                    31834.48,
                    31881.15,
                    31838.24,
                    31881.15,
                    3.76877952
                ],
                [
                    1611511620,
                    31827.18,
                    31892.47,
                    31892.47,
                    31837.93,
                    10.96383652
                ],
                [
                    1611511560,
                    31876.06,
                    31914.27,
                    31892.54,
                    31893.17,
                    2.21617718
                ],
                [
                    1611511500,
                    31878.79,
                    31924,
                    31910.06,
                    31889.49,
                    10.3016177
                ],
                [
                    1611511440,
                    31885.88,
                    31919.65,
                    31911.23,
                    31910.06,
                    6.24052656
                ],
                [
                    1611511380,
                    31871.17,
                    31911.23,
                    31873.04,
                    31910.86,
                    3.34573404
                ],
                [
                    1611511320,
                    31828.98,
                    31873.03,
                    31859.58,
                    31873.03,
                    9.76701594
                ],
                [
                    1611511260,
                    31820,
                    31859.93,
                    31845.57,
                    31859.93,
                    12.30526672
                ],
                [
                    1611511200,
                    31825.01,
                    31897.67,
                    31890.26,
                    31845.57,
                    16.93091335
                ],
                [
                    1611511140,
                    31878.49,
                    31910.24,
                    31878.78,
                    31895.32,
                    7.22547301
                ],
                [
                    1611511080,
                    31860.33,
                    31910.19,
                    31861.33,
                    31879.15,
                    11.11026653
                ],
                [
                    1611511020,
                    31855.83,
                    31870.01,
                    31863.22,
                    31858.78,
                    2.87612778
                ],
                [
                    1611510960,
                    31850.55,
                    31870.01,
                    31852.9,
                    31863.19,
                    3.92245545
                ],
                [
                    1611510900,
                    31850.64,
                    31888,
                    31873.54,
                    31853.03,
                    8.28720087
                ],
                [
                    1611510840,
                    31872.11,
                    31889.54,
                    31878.36,
                    31873.54,
                    11.1581581
                ],
                [
                    1611510780,
                    31875,
                    31911.1,
                    31902.01,
                    31875,
                    4.71739219
                ],
                [
                    1611510720,
                    31894.7,
                    31921.89,
                    31905.01,
                    31902.72,
                    9.59949411
                ],
                [
                    1611510660,
                    31898.25,
                    31941.35,
                    31941.35,
                    31901.53,
                    10.36335176
                ],
                [
                    1611510600,
                    31933,
                    31993.52,
                    31993.52,
                    31944.13,
                    9.88385899
                ],
                [
                    1611510540,
                    31914.11,
                    32010.84,
                    31914.11,
                    31976.42,
                    21.92743359
                ],
                [
                    1611510480,
                    31910.61,
                    31914.63,
                    31913.33,
                    31914.11,
                    1.90144295
                ],
                [
                    1611510420,
                    31911.91,
                    31948.4,
                    31931.68,
                    31913.33,
                    6.73191239
                ],
                [
                    1611510360,
                    31911.04,
                    31941.5,
                    31911.37,
                    31931.92,
                    16.23115144
                ],
                [
                    1611510300,
                    31911.14,
                    31941.5,
                    31911.14,
                    31911.37,
                    11.61320478
                ],
                [
                    1611510240,
                    31900.68,
                    31911.31,
                    31911.31,
                    31911.14,
                    6.62701715
                ],
                [
                    1611510180,
                    31900.63,
                    31925.78,
                    31910.2,
                    31911.39,
                    11.80486172
                ],
                [
                    1611510120,
                    31908.86,
                    31922.21,
                    31922.21,
                    31910.39,
                    10.5122613
                ],
                [
                    1611510060,
                    31920.01,
                    31952.24,
                    31945.74,
                    31921.87,
                    5.83948427
                ],
                [
                    1611510000,
                    31945.72,
                    31979.77,
                    31979.77,
                    31945.73,
                    4.62516568
                ],
                [
                    1611509940,
                    31940.9,
                    31980.22,
                    31969.23,
                    31980.22,
                    5.07875534
                ],
                [
                    1611509880,
                    31937.12,
                    32004.55,
                    31937.12,
                    31969.12,
                    11.52291437
                ],
                [
                    1611509820,
                    31944.24,
                    32005.58,
                    31969.26,
                    31944.24,
                    8.12479093
                ],
                [
                    1611509760,
                    31964.49,
                    32008.55,
                    31966.42,
                    31964.67,
                    16.04529114
                ],
                [
                    1611509700,
                    31965.68,
                    32000.68,
                    32000.68,
                    31965.68,
                    20.30210461
                ],
                [
                    1611509640,
                    31974.05,
                    32000.68,
                    31997.27,
                    31999.99,
                    23.82669646
                ],
                [
                    1611509580,
                    31959.27,
                    32000,
                    31978.82,
                    32000,
                    23.76403017
                ],
                [
                    1611509520,
                    31878.79,
                    31978.93,
                    31909.64,
                    31978.85,
                    22.02815357
                ],
                [
                    1611509460,
                    31875.33,
                    31911.66,
                    31880.66,
                    31909.58,
                    18.4231692
                ],
                [
                    1611509400,
                    31838.11,
                    31880.66,
                    31851.88,
                    31880.65,
                    11.22609477
                ],
                [
                    1611509340,
                    31857.65,
                    31905.95,
                    31900.35,
                    31858.4,
                    24.04840394
                ],
                [
                    1611509280,
                    31850.11,
                    31903.19,
                    31856.75,
                    31900.35,
                    4.62138844
                ],
                [
                    1611509220,
                    31831.3,
                    31860.84,
                    31848.79,
                    31856.74,
                    7.56971533
                ],
                [
                    1611509160,
                    31815.73,
                    31853.37,
                    31825.77,
                    31853.37,
                    23.22272002
                ],
                [
                    1611509100,
                    31815.69,
                    31856.75,
                    31856.75,
                    31825.61,
                    13.85758134
                ],
                [
                    1611509040,
                    31852.13,
                    31869.18,
                    31869.18,
                    31857.14,
                    22.41753338
                ],
                [
                    1611508980,
                    31869.12,
                    31873.61,
                    31869.13,
                    31869.18,
                    2.74517232
                ],
                [
                    1611508920,
                    31867.28,
                    31901.38,
                    31867.29,
                    31876.17,
                    29.7660977
                ],
                [
                    1611508860,
                    31867.03,
                    31905.83,
                    31905.83,
                    31867.29,
                    4.95031384
                ],
                [
                    1611508800,
                    31884.07,
                    31921.11,
                    31884.07,
                    31905.82,
                    6.5341826
                ],
                [
                    1611508740,
                    31884.04,
                    31921.16,
                    31899.99,
                    31887.42,
                    12.30461816
                ],
                [
                    1611508680,
                    31869.95,
                    31900,
                    31869.95,
                    31900,
                    5.52054289
                ],
                [
                    1611508620,
                    31859.77,
                    31882.82,
                    31864.05,
                    31869.95,
                    6.02832951
                ],
                [
                    1611508560,
                    31820.78,
                    31900,
                    31829.64,
                    31869.28,
                    26.54797227
                ],
                [
                    1611508500,
                    31829.63,
                    31879.75,
                    31879.75,
                    31829.64,
                    7.78777608
                ],
                [
                    1611508440,
                    31865.88,
                    31896.4,
                    31888.36,
                    31881.69,
                    5.00191808
                ],
                [
                    1611508380,
                    31842.87,
                    31900,
                    31845.88,
                    31888.75,
                    17.28489257
                ],
                [
                    1611508320,
                    31814.01,
                    31871.65,
                    31823.84,
                    31845.87,
                    16.81576347
                ],
                [
                    1611508260,
                    31822.76,
                    31916.44,
                    31914.95,
                    31822.76,
                    7.1031074
                ],
                [
                    1611508200,
                    31879.04,
                    31925.45,
                    31895.98,
                    31914.18,
                    14.1712482
                ],
                [
                    1611508140,
                    31875.95,
                    31918.14,
                    31914.12,
                    31896.02,
                    20.63746197
                ],
                [
                    1611508080,
                    31908.12,
                    31981.35,
                    31981.35,
                    31913.6,
                    18.78955246
                ],
                [
                    1611508020,
                    31935.48,
                    31981.36,
                    31945.33,
                    31981.36,
                    16.5873989
                ],
                [
                    1611507960,
                    31938.74,
                    31967.58,
                    31948.59,
                    31945.33,
                    15.43181763
                ],
                [
                    1611507900,
                    31868.54,
                    31967.53,
                    31869.09,
                    31953.71,
                    21.85115755
                ],
                [
                    1611507840,
                    31869.4,
                    31907.85,
                    31891.54,
                    31872.6,
                    41.10893638
                ],
                [
                    1611507780,
                    31841.62,
                    31899.99,
                    31875.98,
                    31891.54,
                    21.97596998
                ],
                [
                    1611507720,
                    31781.08,
                    31884.18,
                    31793.83,
                    31869.64,
                    6.80797887
                ],
                [
                    1611507660,
                    31730.44,
                    31812.8,
                    31733.2,
                    31794.21,
                    16.07095011
                ],
                [
                    1611507600,
                    31680.95,
                    31776.77,
                    31774.39,
                    31729.92,
                    38.62217673
                ],
                [
                    1611507540,
                    31774.38,
                    31822.84,
                    31813.17,
                    31774.39,
                    4.96599401
                ],
                [
                    1611507480,
                    31803.21,
                    31853.83,
                    31832.64,
                    31813.17,
                    7.04322927
                ],
                [
                    1611507420,
                    31802.66,
                    31862.53,
                    31862.53,
                    31832.57,
                    15.33472751
                ],
                [
                    1611507360,
                    31828.02,
                    31868.15,
                    31828.02,
                    31864.18,
                    18.3588702
                ],
                [
                    1611507300,
                    31802.03,
                    31837.31,
                    31802.03,
                    31828.03,
                    7.95365029
                ]
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

    context 'pagination' do
      it 'works for cursors that are URI encoded' do
        result = ExecuteSearch.call({ search_type: :currencies, cursor: CGI.escape(Base64.encode64('before__Bitcoin')) }, :test, stubs)

        expect(result[:data]).to eq([{ 'name' => 'Aave', 'symbol' => 'AAVE' }])
      end

      it 'works for cursors that are not URI encoded' do
        result = ExecuteSearch.call({ search_type: :currencies, cursor: Base64.encode64('before__Bitcoin') }, :test, stubs)

        expect(result[:data]).to eq([{ 'name' => 'Aave', 'symbol' => 'AAVE' }])
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

    context 'getting rates' do
      it 'returns a list of rates' do
        result = ExecuteSearch.call({ search_type: :rates, symbols: 'BTC-USD', sort: 'time DESC', limit: 3 }, :test, stubs)
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
