require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject(:user) { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    
    context 'when email format is invalid' do
      it 'is invalid' do
        user.email = 'invalid_email'
        expect(user).not_to be_valid
      end
    end

    context 'when password format is invalid' do
      it 'is invalid without uppercase' do
        user.password = 'password123!'
        expect(user).not_to be_valid
      end

      it 'is invalid without special character' do
        user.password = 'Password123'
        expect(user).not_to be_valid
      end
    end
  end

  describe '#full_name' do
    it 'returns the full name' do
      user = build(:user, first_name: 'John', last_name: 'Doe')
      expect(user.full_name).to eq('John Doe')
    end
  end
end 