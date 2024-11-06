module Api
  module V1
    class BaseController < ApplicationController
      before_action :authorize_request
      
      private

      def authorize_request
        @current_user = Auth::AuthorizeApiRequest.new(request.headers['Authorization']).call
      rescue ExceptionHandler::AuthenticationError => e
        render json: { error: e.message }, status: :unauthorized
      end

      def current_user
        @current_user
      end
    end
  end
end 