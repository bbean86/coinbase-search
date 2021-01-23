class Search < ApplicationRecord
  validates :search_type, :query_params, :expires_at, presence: true

  scope :by_type, ->(search_type) { where(search_type: search_type) }
  scope :by_query, ->(query_params) { where(query_params: query_params) }
  scope :by_limit_and_cursor, ->(limit, cursor) { where(limit: limit, cursor: cursor) }
end
