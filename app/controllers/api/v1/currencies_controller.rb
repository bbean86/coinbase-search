class Api::V1::CurrenciesController < ApplicationController
  include Searchable

  private

  def search_params
    params.permit(:name, :limit, :cursor, :sort).to_hash.merge(search_type: :currencies, expires_at: Time.now + 1.day)
  end
end
