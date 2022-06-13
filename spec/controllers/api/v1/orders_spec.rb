require 'rails_helper'

RSpec.describe "Api::V1::Orders", type: :request do
  describe "CRUD" do
    let!(:order) { create :order }

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
    end
  end
end
