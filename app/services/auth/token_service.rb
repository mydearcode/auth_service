module Auth
  class TokenService
    def self.encode_user(user, exp = 24.hours.from_now)
      payload = {
        user_id: user.id,
        email: user.email,
        role: user.role
      }
      
      JsonWebToken.encode(payload, exp)
    end

    def self.decode_token(token)
      decoded = JsonWebToken.decode(token)
      raise ExceptionHandler::InvalidToken, 'Invalid token' if decoded.nil?
      decoded
    end
  end
end 