require 'rails_helper'

RSpec.describe "Api::V1::Orders", type: :request do
  describe "CRUD" do
    let!(:order) { create :order, :with_products }

    let(:order_params) do
      {
        order: {
          product_ids_and_quantities: [
            { product_id: FactoryBot.create(:product).id, quantity: 2},
            { product_id: FactoryBot.create(:product).id, quantity: 3}
          ]
        }
      }
    end

    context 'GET order' do
      it 'does not return the order for unlogged' do
        get api_v1_orders_url, as: :json
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns the orders' do
        get api_v1_orders_url, headers: { Authorization: JsonWebToken.encode(user_id: order.user_id) }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(order.user.orders.count).to eql(json_response['data'].count)
      end

      it 'returns single order' do
        get api_v1_order_url(order), headers: { Authorization: JsonWebToken.encode(user_id: order.user_id) }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        included_product_attr = json_response['included'][0]['attributes']
        expect(order.products.first.title).to eql(included_product_attr['title'])
      end
    end

    context 'POST order' do
      it 'does not create the order for unlogged' do
        post api_v1_orders_url, params: order_params, as: :json
        expect(response).to have_http_status(:forbidden)
      end

      it 'creates the order with two products' do
        expect do
          post api_v1_orders_url, params: order_params,
               headers: { Authorization: JsonWebToken.encode(user_id: order.user_id) }
          expect(response).to have_http_status(:created)
        end.to change(Order, :count).by(+1)
      end

      it 'creates order with two products and placements' do
        expect do
          expect do
            post api_v1_orders_url, params: order_params, as: :json,
                 headers: { Authorization: JsonWebToken.encode(user_id: order.user_id)}
          end.to change(Placement, :count).by(2)
        end.to change(Order, :count).by(1)
      end
    end
  end
end
