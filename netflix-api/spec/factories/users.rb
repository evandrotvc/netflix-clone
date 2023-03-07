FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password_digest { Faker::Crypto.sha1 }
  end
end
