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

  scope :paginated, lambda { |cursor|
    return unless cursor.present?

    direction, name = Base64.decode64(cursor).split('__')

    operators = {
      'after' => '>',
      'before' => '<'
    }

    where("name #{operators[direction]} '#{name}'")
  }
end
