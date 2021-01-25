class Coinbase::Rate < ApplicationRecord
  include PgSearch::Model

  belongs_to :pair

  scope :by_symbols, ->(symbols) { where(coinbase_pairs: { symbols: symbols }) }
  scope :by_interval, ->(interval) { where(interval: interval) }

  scope :paginated, lambda { |cursor|
    return unless cursor.present?

    direction, time = Base64.decode64(cursor).split('__')

    operators = {
      'after' => '>',
      'before' => '<'
    }

    where("time #{operators[direction]} '#{DateTime.strptime(time, '%s')}'")
  }

  def self.allowed_sort_columns
    ['time ASC', 'time DESC']
  end
end
