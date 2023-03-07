require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Warden::Test::Helpers
  include Devise::Test::ControllerHelpers

  let(:valid_attributes) {{
    name: 'evandro',
    password_digest: '1234',
    email: 'evandro@gmail.com',
  }}

  let(:invalid_attributes) {{
    Name: 'evandro',
    email: 'evandro@gmail.com',
  }}

  describe "POST /create" do
    context "with valid parameters" do
      let(:do_request) do
        post :create, params: { user: valid_attributes  }, as: :json
      end

      it "creates a new User" do
        expect { do_request }.to change(User, :count).by(1)
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      let(:do_request) do
        post :create, params:  { user: invalid_attributes  }, as: :json
      end
      it "does not create a new User" do
        do_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
