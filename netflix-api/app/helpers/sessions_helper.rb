module SessionsHelper
  def sign_in(user)
    session[:user_id] = user.id
    token = JsonWebToken.encode(user_id: @user.id)
    time = Time.now + 24.hours.to_i
    render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     email: @user.email, user_id: user.id }, status: :ok
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def block_access
    return unless current_user.present?

    redirect_to users_path
  end

  def logged_in?
    !current_user.nil?
  end

  def sign_out
    session.delete(:user_id)
    @current_user = nil
  end
end
