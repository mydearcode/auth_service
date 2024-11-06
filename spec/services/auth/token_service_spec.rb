require 'rails_helper'

RSpec.describe Auth::TokenService do
  let(:user) { create(:user) }

  describe '.encode_user' do
    it 'returns a valid JWT token' do
      token = described_class.encode_user(user)
      expect(token).to be_a(String)
      
      decoded_token = JsonWebToken.decode(token)
      expect(decoded_token[:user_id]).to eq(user.id)
      expect(decoded_token[:email]).to eq(user.email)
      expect(decoded_token[:role]).to eq(user.role)
    end
  end

  describe '.decode_token' do
    context 'with valid token' do
      it 'returns decoded payload' do
        token = described_class.encode_user(user)
        decoded = described_class.decode_token(token)
        expect(decoded[:user_id]).to eq(user.id)
      end
    end

    context 'with invalid token' do
      it 'raises InvalidToken error' do
        expect {
          described_class.decode_token('invalid_token')
        }.to raise_error(ExceptionHandler::InvalidToken)
      end
    end
  end
end 