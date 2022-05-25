require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "CRUD" do
    let(:user) { create :user }

    let!(:user_params) do
      {
        user: {
          email: Faker::Internet.email,
          password: Faker::Internet.password
        }
      }
    end

    context 'GET user' do
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

      it 'returns the correct user' do
        get api_v1_user_url('fake_id')
        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq("Not found")
      end
    end

    context 'POST user' do
      let(:create_user) { post '/api/v1/users', params: user_params }

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

    context 'UPDATE user' do
      it 'updates user' do
        patch api_v1_user_url(user), params: user_params, headers: { Authorization: JsonWebToken.encode(user_id: user.id)}
        expect(response).to have_http_status(:success)
        expect(User.find(user.id).email).to eql(user_params[:user][:email])
      end

      it 'does not update user when invalid params are sent' do
        user_params[:user][:email] = 'invalid.email'
        patch api_v1_user_url(user), params: user_params, headers: { Authorization: JsonWebToken.encode(user_id: user.id) }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should forbid update user' do
        patch api_v1_user_url(user), params: user_params
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'DELETE the user' do
      let!(:user) { create :user, :user_with_product }

      it 'deletes the user' do
        expect do
          delete api_v1_user_url(user), headers: { Authorization: JsonWebToken.encode(user_id: user.id) }
          expect(response).to have_http_status(:no_content)
        end.to change(User, :count).by(-1)
      end

      it 'should forbid destroy user' do
        expect do
          delete api_v1_user_url(user)
          expect(response).to have_http_status(:forbidden)
        end.to change(User, :count).by(0)
      end

      it 'destroy user should destroy linked product' do
        expect do
          user.destroy
        end.to change(Product, :count).by(-1)
      end
    end
  end
end
