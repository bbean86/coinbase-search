class Coinbase::Rate < ApplicationRecord
  include CursorPagination

  belongs_to :pair, class_name: 'Coinbase::Pair'

  scope :by_symbols, ->(symbols) { includes(:pair).where(coinbase_pairs: { symbols: symbols }) }
  scope :by_interval, ->(interval) { where(interval: interval) }

  validates :time, uniqueness: { scope: %i[pair_id interval] }

  paginate_on :time do |time|
    DateTime.strptime(time, '%s')
  end

  def self.allowed_sort_columns
    ['time ASC', 'time DESC']
  end
end
