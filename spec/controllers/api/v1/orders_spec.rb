require 'rails_helper'

RSpec.describe "Api::V1::Orders", type: :request do
  describe "CRUD" do
    let!(:order) { create :order, :with_products }

    context 'GET order' do
      it 'does not return the order to unlogged' do
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
  end
end
