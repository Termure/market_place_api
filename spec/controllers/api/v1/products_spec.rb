require 'rails_helper'

RSpec.describe "Api::V1::Products", type: :request do
  describe "CRUD" do
    let!(:product) { create :product }

    context 'GET product' do
      it 'returns the product' do
        get api_v1_product_url(product), as: :json
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eql(product.title)
      end

      it 'does not return the product' do
        get api_v1_product_url('fake_product')
        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq("Product Not found")
      end

      it 'should show products' do
        get api_v1_products_url()
        expect(response).to have_http_status(:success)
      end
    end
  end
end
