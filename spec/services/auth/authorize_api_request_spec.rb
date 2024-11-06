require 'rails_helper'

RSpec.describe Auth::AuthorizeApiRequest do
  let(:user) { create(:user) }
  
  # Valid token subject
  subject(:valid_request_obj) { described_class.new("Bearer #{valid_token}") }
  
  # Invalid token subject
  subject(:invalid_request_obj) { described_class.new('Bearer invalid_token') }
  
  # Missing token subject
  subject(:missing_token_request_obj) { described_class.new(nil) }
  
  # Expired token subject
  subject(:expired_token_request_obj) { described_class.new("Bearer #{expired_token}") }

  describe '#call' do
    context 'with valid token' do
      let(:valid_token) { token_generator(user.id) }

      it 'returns the user' do
        result = valid_request_obj.call
        expect(result).to eq(user)
      end
    end

    context 'with invalid token' do
      let(:valid_token) { 'invalid_token' }
      
      it 'raises InvalidToken error' do
        expect { invalid_request_obj.call }.to raise_error(
          ExceptionHandler::InvalidToken,
          /Invalid token/
        )
      end
    end

    context 'with expired token' do
      let(:expired_token) { expired_token_generator(user.id) }

      it 'raises ExpiredSignature error' do
        expect { expired_token_request_obj.call }.to raise_error(
          ExceptionHandler::ExpiredSignature,
          /Token has expired/
        )
      end
    end

    context 'with missing token' do
      it 'raises MissingToken error' do
        expect { missing_token_request_obj.call }.to raise_error(
          ExceptionHandler::MissingToken,
          /Missing token/
        )
      end
    end
  end

  private

  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  def expired_token_generator(user_id)
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end
end 