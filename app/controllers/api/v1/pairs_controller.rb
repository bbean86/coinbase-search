class Api::V1::PairsController < ApplicationController
  include Searchable

  private

  def search_params
    params.permit(
      :symbols,
      :base_currency,
      :quote_currency,
      :status,
      :limit,
      :sort,
      :cursor
    ).to_hash.merge(search_type: :pairs, expires_at: Time.now + 1.day)
  end
end
