FactoryBot.define do
  factory :product do
    title { Faker::Book.title }
    price { rand(0..2**32 - 1) }
    published { Faker::Boolean }
    user
    quantity { rand(0..50) }

    before :create do
      create :user
    end
  end
end
