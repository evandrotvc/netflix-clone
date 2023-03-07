require 'rails_helper'

RSpec.describe User do
  subject(:user) { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password_digest) }
  end

  describe 'user create' do
    before { user.save }

    it { is_expected.to be_persisted }
  end
end
