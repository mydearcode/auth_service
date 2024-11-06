require 'rails_helper'

RSpec.describe Auth::Authenticator do
  let(:user) { create(:user, password: 'Password123!') }
  
  describe '#authenticate' do
    context 'with valid credentials' do
      let(:auth) { described_class.new(user.email, 'Password123!') }

      it 'returns the user' do
        expect(auth.authenticate).to eq(user)
      end
    end

    context 'with invalid password' do
      let(:auth) { described_class.new(user.email, 'wrong_password') }

      it 'raises authentication error' do
        expect {
          auth.authenticate
        }.to raise_error(ExceptionHandler::AuthenticationError)
      end
    end

    context 'with invalid email' do
      let(:auth) { described_class.new('wrong@email.com', 'Password123!') }

      it 'raises authentication error' do
        expect {
          auth.authenticate
        }.to raise_error(ExceptionHandler::AuthenticationError)
      end
    end

    context 'with case-insensitive email' do
      let(:auth) { described_class.new(user.email.upcase, 'Password123!') }

      it 'returns the user' do
        expect(auth.authenticate).to eq(user)
      end
    end
  end
end 