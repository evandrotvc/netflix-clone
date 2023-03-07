class SessionsController < ApplicationController
  before_action :block_access, except: [:destroy]

  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)

    if @user && @user.authenticate(params[:session][:password])
      sign_in(@user)

      redirect_to user_path(@user), status: :ok
    else
      flash[:danger] = 'Invalid email/password combination'
      head :unauthorized
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
