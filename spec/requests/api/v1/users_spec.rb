require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "CRUD" do
    context 'GET user' do
      let!(:user) { create :user}

      before do
        get "/api/v1/users/#{user.id}", as: :json # or get api_v1_user_url(user)
      end

      it 'responds with status success (200)' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the correct user' do
        json_response = JSON.parse(response.body)
        expect(json_response['email']).to eq(user.email)
      end
    end
  end
end
