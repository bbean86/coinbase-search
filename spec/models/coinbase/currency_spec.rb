require 'rails_helper'

RSpec.describe Coinbase::Currency, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :symbol }

  describe '.search_by_name' do
    let!(:ada) { Coinbase::Currency.create(name: 'Cardano', symbol: 'ADA') }
    let!(:btc) { Coinbase::Currency.create(name: 'Bitcoin', symbol: 'BTC') }
    let!(:bch) { Coinbase::Currency.create(name: 'Bitcoin Cash', symbol: 'BCH') }

    it 'fuzzy matches a record by name' do
      results = Coinbase::Currency.search_by_name 'B'
      expect(results).to eq([btc, bch])
    end

    it 'matches regardless of case' do
      results = Coinbase::Currency.search_by_name 'b'
      expect(results).to eq([btc, bch])
    end
  end
end
