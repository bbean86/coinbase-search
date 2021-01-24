module Searchable
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

  def search_params
    raise 'Not yet implemented'
  end
end
