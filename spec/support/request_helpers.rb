module RequestHelpers
  def json_response
    @json_response ||= JSON.parse(response.body)
  end

  def auth_header(token)
    ActionController::HttpAuthentication::Token.encode_credentials(token)
  end
end 