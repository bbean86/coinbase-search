class Search < ApplicationRecord
  validates :search_type, :expires_at, presence: true
  validates :search_type, uniqueness: { scope: %i[query_params limit cursor sort] }

  validates :limit, numericality: { greater_than: 0 }, allow_nil: true
  validate :cursor_is_base64?, if: :cursor?
  validate :cursor_prefix_valid?, if: :cursor?
  validates :sort, inclusion: { in: Coinbase::Currency.allowed_sort_columns }, if: :validate_currencies_sort?
  validates :sort, inclusion: { in: Coinbase::Pair.allowed_sort_columns }, if: :validate_pairs_sort?
  validates :sort, inclusion: { in: Coinbase::Rate.allowed_sort_columns }, if: :validate_rates_sort?

  scope :by_type, ->(search_type) { where(search_type: search_type) }
  scope :by_query, ->(query_params) { where(query_params: query_params) }

  scope :by_limit_and_cursor, ->(limit, cursor) { where(limit: limit, cursor: cursor) }
  scope :by_sort, ->(sort) { where(sort: sort) }

  SEARCH_TYPES = {
    currencies: 'currencies',
    pairs: 'pairs',
    rates: 'rates'
  }.freeze

  def cursor_is_base64?
    cursor.is_a?(String) && Base64.strict_encode64(Base64.decode64(cursor)) == cursor
  end

  def cursor_prefix_valid?
    c = Base64.decode64(cursor)
    c.start_with?('before__') || c.start_with?('after__')
  end

  def validate_currencies_sort?
    sort.present? && search_type == SEARCH_TYPES[:currencies]
  end

  def validate_pairs_sort?
    sort.present? && search_type == SEARCH_TYPES[:pairs]
  end

  def validate_rates_sort?
    sort.present? && search_type == SEARCH_TYPES[:rates]
  end
end
