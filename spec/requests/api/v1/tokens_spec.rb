require 'rails_helper'

RSpec.describe "Api::V1::Tokens", type: :request do
  describe "token" do
    let!(:user_parms) do
      {
        user: {
          email:    Faker::Internet.email,
          password: BCrypt::Password.create(Faker::Internet.password)
        }
      }
    end

    context 'GET token' do
      before do
        post api_v1_users_url, params: user_parms
      end

      it 'receive the token' do
        post api_v1_tokens_url, params: user_parms
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['token']).to be
      end

      it 'not receive the token' do
        user_parms[:user][:email] = 'test.email'
        post api_v1_tokens_url, params: user_parms
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
