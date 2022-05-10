require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "CRUD" do
    context 'GET user' do
      let(:user) { create :user}

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

    context 'POST user' do
      let(:create_user) { post '/api/v1/users', params: user_params }

      let!(:user_params) do
        {
          user: {
            email: Faker::Internet.email,
            password: Faker::Internet.password
          }
        }
      end

      it 'creates a new user' do
        expect { create_user }.to change(User, :count).by(+1)
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(User.last.id)
      end

      it 'does not creates user with taken email' do
        create_user
        expect { post api_v1_users_url, params: user_params }.to_not change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
