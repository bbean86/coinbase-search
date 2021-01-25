module Searchable
  extend ActiveSupport::Concern

  def index
    if result.present?
      if result[:errors]&.any?
        render json: { message: result[:errors].full_messages.join(', ') }, status: :unprocessable_entity
      else
        render json: result.as_json
      end
    else
      render status: 404
    end
  end

  def search_params
    raise 'Not yet implemented'
  end

  def result
    @result ||= ExecuteSearch.call(search_params)
  end
end
