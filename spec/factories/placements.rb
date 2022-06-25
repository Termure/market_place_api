FactoryBot.define do
  factory :placement do
    order { FactoryBot.create(:order) }
    product { FactoryBot.create(:product) }
    quantity { rand(0..100) }
  end
end
