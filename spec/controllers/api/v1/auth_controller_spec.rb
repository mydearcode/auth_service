require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :controller do
  let(:user) { create(:user, password: 'Password123!') }

  describe 'POST #register' do
    let(:valid_params) do
      {
        user: {
          email: 'test@example.com',
          password: 'Password123!',
          password_confirmation: 'Password123!',
          first_name: 'Test',
          last_name: 'User'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new user and returns a token' do
        expect {
          post :register, params: valid_params, as: :json
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response['token']).to be_present
        expect(json_response['user']['email']).to eq('test@example.com')
      end
    end

    context 'with invalid parameters' do
      it 'returns error messages' do
        post :register, params: { 
          user: valid_params[:user].merge(email: 'invalid') 
        }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'POST #login' do
    let(:login_params) do
      {
        auth: {
          email: user.email,
          password: 'Password123!'
        }
      }
    end

    context 'with valid credentials' do
      it 'returns user and token' do
        post :login, params: login_params, as: :json
        
        expect(response).to have_http_status(:ok)
        expect(json_response['token']).to be_present
        expect(json_response['user']['email']).to eq(user.email)
      end
    end

    context 'with invalid credentials' do
      it 'returns authentication error' do
        post :login, params: { 
          auth: { email: user.email, password: 'wrong' }
        }, as: :json
        
        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Invalid credentials')
      end
    end
  end

  describe 'GET #me' do
    context 'with valid token' do
      it 'returns current user information' do
        # Create and set token
        token = Auth::TokenService.encode_user(user)
        request.headers['Authorization'] = "Bearer #{token}"
        
        get :me, as: :json
        
        expect(response).to have_http_status(:ok)
        expect(json_response['email']).to eq(user.email)
      end
    end

    context 'without token' do
      it 'returns unauthorized' do
        get :me, as: :json
        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Missing token')
      end
    end
  end
end 