require 'rails_helper'

RSpec.describe Search, type: :model do
  let!(:search) { Search.create!(search_type: 'currencies', query_params: { name: 'Bit' }, expires_at: Time.now + 1.day) }
  let(:cursor) { Base64.strict_encode64('after__Bitcoin') }
  let!(:search_2) { Search.create!(search_type: 'currencies', query_params: { name: 'Eth' }, expires_at: Time.now + 1.day, limit: 10, cursor: cursor) }
  let!(:search_3) { Search.create!(search_type: 'currencies', query_params: { name: 'Doge' }, expires_at: Time.now + 1.day) }

  it { is_expected.to validate_presence_of(:search_type) }
  it { is_expected.to validate_presence_of(:expires_at) }

  it 'can scope by search_type' do
    expect(Search.by_type('currencies')).to eq([search, search_2, search_3])
  end

  it 'can scope by query_params' do
    expect(Search.by_query({ name: 'Bit' })).to eq([search])
  end

  it 'can scope by limit and cursor' do
    expect(Search.by_limit_and_cursor(10, cursor)).to eq([search_2])
  end
end
