module AuthHelper
  def auth_headers(user)
    token = Auth::TokenService.encode_user(user)
    { 'Authorization' => token }
  end

  def json_response
    JSON.parse(response.body).with_indifferent_access
  end
end 