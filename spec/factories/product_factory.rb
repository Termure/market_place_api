FactoryBot.define do
  factory :product do
    title { Faker::Book.title }
    price { Faker::Number.decimal }
    published { Faker::Boolean }
  end
end
