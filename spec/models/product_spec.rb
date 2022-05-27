require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    let!(:product) { create :product }

    context 'validates product based on price' do
      it 'product should be invalid when price is negative' do
        product.price = -1
        expect(product.valid?).to eql false
      end

      it 'product should be valid when price is positive' do
        product.price = 10
        expect(product.valid?).to eql true
      end
    end
  end
end
