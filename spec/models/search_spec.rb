require 'rails_helper'

RSpec.describe Search, type: :model do
  let(:search) { Search.create(search_type: 'currencies', query_params: { name: 'Bit' }) }

  it 'can scope by search_type' do
    expect(Search.by_type('currencies')).to eql(search)
  end

  it 'can scope by query_params' do
    expect(Search.by_query_params({ name: 'Bit' })).to eql(search)
  end
end
