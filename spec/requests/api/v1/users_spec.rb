require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "CRUD" do
    let!(:user) { create :user}

    it 'GET user' do
      get "/api/v1/users/#{user.id}", as: :json # or get api_v1_user_url(user)
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['email']).to eq(user.email)
    end
  end
end
