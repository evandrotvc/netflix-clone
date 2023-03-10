require 'rails_helper'

RSpec.describe MovieLiked do
  subject(:movie_liked) { build(:movie_liked) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:movie_id) }
    it { is_expected.to validate_presence_of(:image) }
    it { is_expected.to validate_presence_of(:genres) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'user create' do
    before { movie_liked.save }

    it { is_expected.to be_persisted }
  end
end
