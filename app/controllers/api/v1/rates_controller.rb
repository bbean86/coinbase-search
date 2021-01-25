class Api::V1::RatesController < ApplicationController
  include Searchable

  private

  def search_params
    hash = params.permit(
      :limit,
      :cursor,
      :sort,
      :interval,
      :pair_id
    ).to_hash

    symbols = hash.delete('pair_id')

    hash.merge(
      search_type: :rates,
      expires_at: Time.now + 1.minute,
      symbols: symbols
    )
  end
end
