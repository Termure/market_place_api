FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password_digest { Faker::Internet.password }

    trait :with_products do
      transient do
        val { false }
      end
      after :create do |user, evaluator|
        create :product, published: evaluator.val, user: user
      end
    end
  end
end
