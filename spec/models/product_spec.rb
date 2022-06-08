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

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe 'filter products' do
    let!(:product_one)   { create :product, title: 'Tv 1',  price: 300 }
    let!(:product_two)   { create :product, title: 'BBC 2', price: 100 }
    let!(:product_three) { create :product, title: 'Tv 3',  price: 200 }

    it 'filters products by title' do
      expect(Product.filter_by_title('tv').count).to eql 2
    end

    it 'filters products by title and sort them' do
      expect(Product.filter_by_title('tv').sort_by(&:id)).to match([product_one, product_three])
    end

    it 'filters products with price equal or above to given price' do
      expect(Product.above_or_equal_to_price(200).sort_by(&:price)).to match([product_three, product_one])
    end

    it 'filters products with price equal or lower to given price' do
      expect(Product.bellow_or_equal_to_price(200).sort_by(&:price)).to match([product_two, product_three])
    end

    it 'sorts products by most recent' do
      product_two.update(price: 33)
      expect(Product.recent.to_a).to match([product_one, product_three, product_two])
    end

    it 'search not finds "videoGame" and "100" as min price' do
      search_hash = { keyword: 'videGame', min_price: 100}
      expect(Product.search(search_hash).empty?).to eql true
    end

    it 'search finds cheap TV' do
      search_hash = { x: 'BBC 2', min_price: 50, max_price: 150}
      expect(Product.search(search_hash)).to match([product_two])
    end

    it 'returns all products when no parameters' do
      expect(Product.search({})).to match(Product.all.to_a)
    end

    it 'search filters by product ids' do
      search_hash = { prod_ids: product_one }
      expect(Product.search(search_hash)).to match([product_one])
    end
  end
end
