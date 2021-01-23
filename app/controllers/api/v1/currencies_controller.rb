class Api::V1::CurrenciesController < ApplicationController
  def index
    result = ExecuteSearch.call(search_params)

    if result.present?
      render json: result.as_json
    else
      render status: 404
    end
  end

  private

  def search_params
    params.permit(:name, :limit, :cursor).to_hash.merge(search_type: :currencies, expires_at: Time.now + 1.day)
  end
end
