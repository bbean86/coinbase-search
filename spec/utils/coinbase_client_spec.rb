require 'rails_helper'

describe CoinbaseClient do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) { CoinbaseClient.new conn }

  describe '#currencies' do
    before do
      t = Time.local(2021, 1, 1, 0, 0, 0)
      Timecop.freeze(t)
    end

    after do
      Timecop.return
    end

    it 'signs the request and returns the list of currencies' do
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

      expect(client.currencies).to eq([OpenStruct.new(name: 'Bitcoin', symbol: 'BTC'), OpenStruct.new(name: 'United States Dollar', symbol: 'USD')])
      stubs.verify_stubbed_calls
    end
  end
end
