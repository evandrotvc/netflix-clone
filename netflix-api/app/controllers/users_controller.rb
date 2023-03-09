class UsersController < ApplicationController
  before_action :authorize_request, except: %i[new create]
  before_action :set_user, only: %i[show edit update destroy like]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  def login
    @user = User.find_by_email(params[:email])
    if @user.password_digest == params[:password]
      give_token
    else
      redirect_to home_url
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html do
          redirect_to user_url(@user), notice: 'User was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def like
    MovieLiked.create(movie_params.merge(user_id: @user.id))
    render json: { message: "Movie liked with sucess" }, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = @current_user
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def movie_params
    params.require(:movie).permit(:name, :image_url, :genres, :movie_id)
  end
end
