require 'spec_helper'
require 'rails_helper'

module SpecTestHelper
  def login_admin
    login(:admin)
  end

  def login(user)
    user = User.where(login: user.to_s).first if user.is_a?(Symbol)
    request.session[:user_id] = user.id

    secret = Rails.application.secrets.json_web_token_secret
    encoding = 'HS256'

    request.headers["Authorization"] = JWT.encode({ user_id: user.id }, secret, encoding)
  end

  def current_user
    User.find(request.session[:user])
  end
end

RSpec.configure do |c|
  c.include SpecTestHelper
end
