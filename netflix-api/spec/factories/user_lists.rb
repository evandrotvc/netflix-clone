FactoryBot.define do
  factory :user_list do
    evaluation { 'neutral' }
    wished { false }
    user { create(:user) }
    movie { create(:movie) }
  end
end
