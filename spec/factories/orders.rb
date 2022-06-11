FactoryBot.define do
  factory :order do
    user { create :user }
    total { rand(0..2 ** 31 - 1) }
  end
end
