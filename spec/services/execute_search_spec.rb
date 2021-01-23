require 'rails_helper'

describe ExecuteSearch do
  describe '.call' do
    it 'finds an existing Search by the given search_type and query params' do
      Search.create search_type: 'currencies',
                    query_params: { name: 'Bit' },
                    result: [{ name: 'Bitcon', symbol: 'BTC' }],
                    expires_at: Time.now + 1.hour

      result = ExecuteSearch.call({ search_type: :currencies, name: 'Bit' })

      expect(result[:data]).to_not be_empty
    end
  end
end
