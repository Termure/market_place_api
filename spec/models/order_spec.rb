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

    context 'build placements' do
      let(:product_1) { create :product, quantity: 2}
      let(:product_2) { create :product, quantity: 3}
      it 'builds 2 placements for the order' do
        expect do
          order.build_placements_with_product_ids_and_quantities([
                                                                   { product_id: product_1.id},
                                                                   { product_id: product_2.id}
                                                                 ])
          order.save
        end.to change(Placement, :count).by(2)
      end
    end
  end
end
