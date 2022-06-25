require 'rails_helper'

RSpec.describe Placement, type: :model do
  describe 'placements' do
    let(:placement) { create :placement }

    it 'decreases the product quantity' do
      product = placement.product
      product.quantity = 10
      placement.quantity = 5
      placement.decrement_product_quantity!
      expect(product.quantity).to eql(5)
    end
  end
end
