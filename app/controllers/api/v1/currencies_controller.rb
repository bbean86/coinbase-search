class Api::V1::CurrenciesController < ApplicationController
  def index
    result = ExecuteSearch.call(search_params)

    if result.present?
      if result[:errors]&.any?
        render json: { message: result[:errors].map { |e| e[:message] }.join(', ') }, status: :unprocessable_entity
      else
        render json: result.as_json
      end
    else
      render status: 404
    end
  end

  private

  def search_params
    params.permit(:name, :limit, :cursor, :sort).to_hash.merge(search_type: :currencies, expires_at: Time.now + 1.day)
  end
end
