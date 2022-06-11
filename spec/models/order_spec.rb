require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'order validations' do
    let!(:order) { create :order }

    it 'have a positive total' do
      order.total = -12
      expect(order.valid?).to eql false
      order.total = nil
      expect(order.valid?).to eql false
    end
  end
end
