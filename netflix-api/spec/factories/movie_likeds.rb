FactoryBot.define do
    factory :movie_liked do
      name { Faker::Movie.title }
      movie_id { Faker::Internet.uuid }
      image { 'youtube/last_of_us' }
      genres { 'Drama, Adventure' }
      user { create(:user) }
    end
  end
