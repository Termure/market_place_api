require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user) { create :user }

    context 'validates with shoulda/matchers' do
      subject { user }
      it { is_expected.to be_valid }
      it { is_expected.to validate_uniqueness_of(:email) }
      it { is_expected.to validate_presence_of(:password_digest) }
    end

    context 'validates with expected' do
      it 'email is valid' do
        expect(user).to be_valid
      end

      it 'email is invalid' do
        user.email = 'test.org'
        expect(user).to_not be_valid
      end

      it 'taken email is not valid' do
        duplicate_user = (build :user, email: user.email)
        expect(duplicate_user).to_not be_valid
      end
    end
  end
end
