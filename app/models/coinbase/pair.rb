class Coinbase::Pair < ApplicationRecord
  include PgSearch::Model
  include CursorPagination

  validates :base_currency, :quote_currency, :symbols, :status, presence: true

  pg_search_scope :search_by_symbols,
                  against: :symbols,
                  using: {
                    tsearch: { prefix: true }
                  }

  pg_search_scope :search_by_base_currency,
                  associated_against: {
                    base_currency: :name
                  },
                  using: {
                    tsearch: { prefix: true },
                    trigram: { word_similarity: true },
                    dmetaphone: {}
                  }

  pg_search_scope :search_by_quote_currency,
                  associated_against: {
                    quote_currency: :name
                  },
                  using: {
                    tsearch: { prefix: true },
                    trigram: { word_similarity: true },
                    dmetaphone: {}
                  }

  belongs_to :base_currency, class_name: 'Coinbase::Currency'
  belongs_to :quote_currency, class_name: 'Coinbase::Currency'

  has_many :rates, class_name: 'Coinbase::Rate'

  paginate_on :symbols

  def self.allowed_sort_columns
    ['symbols ASC', 'symbols DESC', 'base_currency ASC', 'base_currency DESC', 'quote_currency ASC', 'quote_currency DESC']
  end
end
