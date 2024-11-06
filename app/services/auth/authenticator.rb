module Auth
  class Authenticator
    def initialize(email, password)
      @email = email
      @password = password
    end

    def authenticate
      user = User.find_by(email: email.downcase)
      return user if user&.authenticate(password)

      raise ExceptionHandler::AuthenticationError, 'Invalid credentials'
    end

    private

    attr_reader :email, :password
  end
end 