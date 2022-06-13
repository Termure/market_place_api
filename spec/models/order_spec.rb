require 'rails_helper'
require './spec/support/order_helpers'

RSpec.configure do |c|
  c.include OrderHelpers
end

RSpec.describe Order, type: :model do
  describe 'order validations' do
    let!(:order) { create :order, :with_products }

    it 'sets the total' do
      set_products_price(order, [10, 20, 30], 60)
      expect(sum_products_price(order)).to eql(order.total)
    end
  end
end
