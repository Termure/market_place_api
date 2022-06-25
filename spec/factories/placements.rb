FactoryBot.define do
  factory :placement do
    order { nil }
    product { nil }
    quantity { rand(0..100) }
  end
end
