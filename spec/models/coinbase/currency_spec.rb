require 'rails_helper'

RSpec.describe Coinbase::Currency, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :symbol }

  let!(:ada) { Coinbase::Currency.create(name: 'Aave', symbol: 'AAVE') }
  let!(:btc) { Coinbase::Currency.create(name: 'Bitcoin', symbol: 'BTC') }
  let!(:bch) { Coinbase::Currency.create(name: 'Bitcoin Cash', symbol: 'BCH') }

  describe '.search_by_name' do
    context 'capitalized name' do
      let(:result) { Coinbase::Currency.search_by_name 'B' }

      it 'fuzzy matches a record by name' do
        expect(result).to eq([btc, bch])
      end
    end

    context 'lowercase name' do
      let(:result) { Coinbase::Currency.search_by_name 'b' }

      it 'matches regardless of case' do
        expect(result).to eq([btc, bch])
      end
    end
  end

  describe '.search_by_symbol' do
    let(:result) { Coinbase::Currency.search_by_symbol 'b' }

    it 'matches regardless of case' do
      expect(result).to eq([btc, bch])
    end
  end

  describe '.paginated' do
    let(:result) { Coinbase::Currency.paginated(Base64.strict_encode64('after__Aave')) }

    it 'returns Pairs indicated by the cursor' do
      expect(result).to eq([btc, bch])
    end
  end
end
