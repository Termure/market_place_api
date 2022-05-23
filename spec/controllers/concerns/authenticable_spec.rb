require 'rails_helper'

RSpec.describe "Authenticable" do
  describe "authenticable" do
    let(:user) { create :user}
    let(:authentication) { MockController.new }

    context 'GET user' do
      it 'gets the user from Authorization token' do
        authentication.request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id)
        expect(authentication.current_user).to be
        expect(user.id).to eql(authentication.current_user.id)
      end

      it 'not gets the user from empty Authorization token' do
        authentication.request.headers['Authorization'] = nil
        expect(authentication.current_user).to be_nil
      end
    end
  end

  class MockController
    include Authenticable
    attr_accessor :request

    def initialize
      mock_request = Struct.new(:headers)
      self.request = mock_request.new({})
    end
  end
end
