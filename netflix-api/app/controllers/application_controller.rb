class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def authorize
    return if logged_in?

    redirect_to root_url
  end
end
