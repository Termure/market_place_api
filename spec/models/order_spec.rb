require 'rails_helper'
require './spec/support/order_helpers'

RSpec.configure do |c|
  c.include OrderHelpers
end

RSpec.describe Order, type: :model do
  describe 'order validations' do
    let!(:order) { create :order, :with_products }

    it 'sets the total' do
      pen  = create :product, price: 10
      book = create :product, price: 20
      pc   = create :product, price: 30

      order.placements = [
        Placement.new(product_id: pen.id,  quantity: 2),
        Placement.new(product_id: book.id, quantity: 2),
        Placement.new(product_id: pc.id,   quantity: 2)
      ]
      order.set_total!
      expected_total = [pen.price * 2, book.price * 2, pc.price * 2].sum
      expect(expected_total).to eql(order.total)
    end

    context 'build placements' do
      let(:product_1) { create :product }
      let(:product_2) { create :product }
      it 'builds 2 placements for the order' do
        expect do
          order.build_placements_with_product_ids_and_quantities([
                                                                   { product_id: product_1.id, quantity: 2},
                                                                   { product_id: product_2.id, quantity: 3}
                                                                 ])
          order.save
        end.to change(Placement, :count).by(2)
      end
    end

    context 'an order should command not to much product than available' do
      let(:product_3) { create :product }

      it 'does not command to much product' do
        order.placements << Placement.new(product_id: product_3.id, quantity: (3 + product_3.quantity))
        expect(order.valid?).to eql false
      end
    end
  end
end
