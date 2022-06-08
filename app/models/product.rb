class Product < ApplicationRecord
  belongs_to :user
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :title, :user_id, presence: true

  scope :filter_by_title,          ->(keyword) { where('lower(title) LIKE ?', "%#{keyword.downcase}%") }
  scope :above_or_equal_to_price,  ->(value) { where('price >= ?', value) }
  scope :bellow_or_equal_to_price, ->(value) { where('price <= ?', value) }
  scope :recent,                   -> { order(:updated_at) }

  class << self
    def search(params = {})
      products = params[:prod_ids].present? ? Product.where(id: params[:prod_ids]) : Product.all
      products = products.filter_by_title(params[:keyword]) if params[:keyword]
      products = products.above_or_equal_to_price(params[:min_price].to_f) if params[:min_price]
      products = products.bellow_or_equal_to_price(params[:max_price].to_f) if params[:max_price]
      products
    end
  end
end
