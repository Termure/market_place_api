require 'rails_helper'
require 'support/helpers'

RSpec.configure do |c|
  c.include Helpers
end
RSpec.describe "Api::V1::Products", type: :request do
  describe "CRUD" do
    let!(:product) { create :product }

    let!(:product_params) do
      {
        product: {
          title:     product.title,
          price:     product.price,
          published: product.published,
          user_id:   product.user_id
        }
      }
    end

    context 'GET product' do
      it 'returns the product', focus: true do # run rspec --tag focus spec
        get api_v1_product_url(product), as: :json
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(product.title).to eql(json_response.dig(:data, :attributes, :title))
        expect(product.user.id.to_s).to eql(json_response.dig(:data, :relationships, :user, :data, :id))
        expect(product.user.email).to eql(json_response.dig(:included, 0, :attributes, :email))
      end

      it 'does not return the product' do
        get api_v1_product_url('fake_product')
        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq("Product Not found")
      end

      it 'should show products' do
        get api_v1_products_url, as: :json
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect_json_response_is_paginated(json_response)
      end
    end

    context 'POST products' do
      it 'creates the product and returns correct response' do
        expect do
          post api_v1_products_url(product_params),
               headers: { Authorization: JsonWebToken.encode(user_id: product.user_id) }
          expect(response).to have_http_status(:created)
        end.to change(Product, :count).by(1)
        json_response = JSON.parse(response.body)
        expect(product.title).to eql(json_response['data']['attributes']['title'])
      end

      it 'not creates the product' do
        expect do
          post api_v1_products_url(product_params)
          expect(response).to have_http_status(:forbidden)
        end.to change(Product, :count).by(0)
      end
    end

    context 'UPDATE products' do
      let!(:product) { create :product }

      it 'updates product' do
        patch api_v1_product_url(product), params: product_params,
              headers: { Authorization: JsonWebToken.encode(user_id: product.user_id) }
        expect(response).to have_http_status(:success)
        expect(Product.find(product.id).title).to eql(product_params[:product][:title])
      end

      it 'not updates the product' do
        create :product
        patch api_v1_product_url(product), params: product_params,
              headers: { Authorization: JsonWebToken.encode(user_id: Product.last.user_id) }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'DELETE product' do
      let!(:product) { create :product }

      it 'deletes the product' do
        expect do
          delete api_v1_product_url(product), headers: { Authorization: JsonWebToken.encode(user_id: product.user_id) }
          expect(response).to have_http_status(:no_content)
        end.to change(Product, :count).by(-1)
      end

      it 'should not delete product' do
        expect do
          delete api_v1_product_url(product), headers: { Authorization: JsonWebToken.encode(user_id: product.user_id + 1) }
          expect(response).to have_http_status(:forbidden)
        end.to change(Product, :count).by(0)
      end
    end
  end
end
