require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  include Warden::Test::Helpers
  include Devise::Test::ControllerHelpers
  include BCrypt

  let!(:user) { create(:user, password_digest: BCrypt::Password.create('123456')) }
  let(:json) { JSON.parse(response.body) }

  describe 'post /create' do
    context 'login success' do
      let(:params) do
        {
          session: {
            email: user.email,
            password: '123456'
          }
        }
      end

      let(:do_request) do
        post :create, params:, as: :json
      end

      before { do_request }

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
        expect(json['token']).should_not be_nil
        expect(json['exp']).should_not be_nil
        expect(json['email']).to eq(user.email)
      end
    end

    context 'login failure' do
      let(:params) do
        {
          session: {
            email: user.email,
            password: '123'
          }
        }
      end

      let(:do_request) do
        post :create, params:, as: :json
      end

      before { do_request }

      it 'returns unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'delete /sign_out' do
    let(:do_request) do
      delete :destroy, as: :json
    end

    it 'must to be redirect to root path' do
      login(user)
      do_request

      expect(session[:user_id]).to eq(nil)
    end
  end
end
