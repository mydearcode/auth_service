module Auth
  class AuthorizeApiRequest
    def initialize(authorization_header)
      @authorization_header = authorization_header
    end

    def call
      user
    end

    private

    attr_reader :authorization_header

    def user
      @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    rescue ActiveRecord::RecordNotFound
      raise ExceptionHandler::InvalidToken, 'Invalid token'
    end

    def decoded_auth_token
      @decoded_auth_token ||= begin
        token = http_auth_header
        raise ExceptionHandler::InvalidToken, 'Token blacklisted' if TokenBlacklist.invalid?(token)
        JsonWebToken.decode(token)
      end
    end

    def http_auth_header
      if authorization_header.present?
        return authorization_header.split(' ').last if authorization_header.start_with?('Bearer ')
        raise ExceptionHandler::InvalidToken, 'Invalid token format'
      end
      
      raise ExceptionHandler::MissingToken, 'Missing token'
    end
  end
end 