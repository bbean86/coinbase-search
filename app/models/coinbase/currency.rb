class Coinbase::Currency < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_by_name,
                  against: :name,
                  using: {
                    tsearch: { prefix: true },
                    trigram: { word_similarity: true },
                    dmetaphone: {}
                  }

  validates :name, :symbol, presence: true
end
