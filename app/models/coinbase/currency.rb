class Coinbase::Currency < ApplicationRecord
  include PgSearch::Model
  include CursorPagination

  pg_search_scope :search_by_name,
                  against: :name,
                  using: {
                    tsearch: { prefix: true },
                    trigram: { word_similarity: true },
                    dmetaphone: {}
                  }

  pg_search_scope :search_by_symbol,
                  against: :symbol,
                  using: {
                    tsearch: { prefix: true }
                  }

  validates :name, :symbol, presence: true

  has_many :pairs, dependent: :destroy, class_name: 'Coinbase::Pair'

  paginate_on :name

  def self.allowed_sort_columns
    ['symbol DESC', 'symbol ASC', 'name DESC', 'name ASC']
  end
end
