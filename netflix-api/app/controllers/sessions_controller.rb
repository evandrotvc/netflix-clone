class SessionsController < ApplicationController
  # before_action :block_access, except: [:create :destroy]
  before_action :authorize_request, except: :create

  def new; end

  def create
    @user = User.find_by(email: login_params[:email])

    if @user && @user.authenticate(login_params[:password])
      sign_in(@user)

    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def destroy
    sign_out
  end

  private

  def login_params
    params.require(:session).permit(:email, :password)
  end
end
