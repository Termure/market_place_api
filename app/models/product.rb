class Product < ApplicationRecord
  belongs_to :user
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :title, :user_id, presence: true

  scope :filter_by_title,          ->(keyword) { where('lower(title) LIKE ?', "%#{keyword.downcase}%") }
  scope :above_or_equal_to_price,  ->(value) { where('price >= ?', value) }
  scope :bellow_or_equal_to_price, ->(value) { where('price <= ?', value) }
  scope :recent,                   -> { order(:updated_at) }
end
