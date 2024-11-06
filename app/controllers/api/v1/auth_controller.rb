module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authorize_request, only: [:register, :login]

      def register
        user = User.new(user_params)
        if user.save
          token = Auth::TokenService.encode_user(user)
          render json: {
            token: token,
            user: user.as_json(except: :password_digest)
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, 
                 status: :unprocessable_entity
        end
      end

      def login
        auth = Auth::Authenticator.new(auth_params[:email], auth_params[:password])
        user = auth.authenticate

        if user
          token = Auth::TokenService.encode_user(user)
          render json: {
            token: token,
            user: user.as_json(except: :password_digest)
          }
        else
          render json: { error: 'Invalid credentials' }, 
                 status: :unauthorized
        end
      end

      def me
        render json: current_user.as_json(except: :password_digest)
      end

      def logout
        # Get the token from the Authorization header
        token = request.headers['Authorization']&.split(' ')&.last
        
        if token
          # Add token to blacklist
          Auth::TokenBlacklist.invalidate(token)
          render json: { message: 'Logged out successfully' }
        else
          render json: { error: 'No token provided' }, status: :unauthorized
        end
      end

      private

      def auth_params
        params.require(:auth).permit(:email, :password)
      end

      def user_params
        params.require(:user).permit(
          :email,
          :password,
          :password_confirmation,
          :first_name,
          :last_name
        )
      end
    end
  end
end 