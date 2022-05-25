FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password_digest { Faker::Internet.password }

    factory :user_with_product do
      after :create do |user|
        create :product, user: user
      end
    end
  end
end
