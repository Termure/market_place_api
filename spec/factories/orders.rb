FactoryBot.define do
  factory :order do
    user { create :user }
    total { rand(0..2 ** 31 - 1) }

    trait :with_products do
      after :build do |order|
        order.products << create_list(:product, 3)
      end
    end
  end
end
