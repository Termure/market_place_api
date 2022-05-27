FactoryBot.define do
  factory :product do
    title { Faker::Book.title }
    price { rand(0..2**32 - 1) }
    published { Faker::Boolean }
    user

    before :create do
      create :user
    end
  end
end
