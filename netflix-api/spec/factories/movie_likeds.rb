FactoryBot.define do
    factory :movie_liked do
      name { 'The last of us' }
      movie_id { '1234' }
      image_url { 'youtube/last_of_us' }
      genres { 'Drama, Adventure' }
      user { create(:user) }
    end
  end
