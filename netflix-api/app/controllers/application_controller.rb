class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  include SessionsHelper

  def authorize
    return if logged_in?

    redirect_to root_url
  end

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    secret = Rails.application.secrets.secret_key_base.to_s

    begin
      @decoded = JWT.decode(token, secret, true).first
      @current_user = User.find(@decoded['user_id'])
    rescue JWT::ExpiredSignature => e
      render json: { errors: e.message, message: 'Token expired.' }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
