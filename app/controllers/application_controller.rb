class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :ensure_json_request
  before_action :authenticate

  # This would obviously not work in a production environment,
  # it would most likely be stored in the database for a User
  # and looked up instead
  TOKEN = '73e2f213f7d875e9e62798b61d3c275ec63f2efe'.freeze

  def ensure_json_request
    return if request.format == :json

    render nothing: true, status: 406
  end

  def authenticate
    authenticate_or_request_with_http_token do |token|
      ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
    end
  end
end
