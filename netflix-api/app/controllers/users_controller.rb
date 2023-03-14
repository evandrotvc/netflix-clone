class UsersController < ApplicationController
  before_action :authorize_request, except: %i[new create]
  before_action :set_user,
    only: %i[show edit update destroy add_wish list_wisheds evaluation
             remove_list_wisheds]

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

  def add_wish
    movie = Movie.find_by(name: movie_params[:name])
    movie = Movie.create!(movie_params) if movie.blank?

    user_list = UserList.find_by(movie_id: movie.id, user_id: @user.id,
      wished: false)&.update(wished: true)

    @user.user_lists.create(movie:, wished: true) if user_list.blank?

    render json: { message: 'Movie added to your wish list with sucess' }, status: :ok
  end

  def list_wisheds
    @movies = Movie.joins(:user_lists).where(user_lists: { user_id: @user.id })

    render json: { movies: @movies }, status: :ok
  end

  def remove_list_wisheds
    @user.user_lists.joins(:movie).find_by(movies: { movie_id: params[:movie_id] })&.update(wished: false)

    render json: { message: 'Movie removed to your list' }, status: :ok
  end

  def evaluation
    movie = Movie.find_by(name: movie_params[:name])
    movie = Movie.create!(movie_params) if movie.blank?

    user_list = @user.user_lists.find_by(movie_id: movie.id)&.update(evaluation: params[:evaluation])

    if user_list.blank?
      @user.user_lists.create(movie:, user: @user,
        evaluation: params[:evaluation])
    end

    render json: { message: 'Movie added to your wish list with sucess' }, status: :ok
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
    params.require(:movie).permit(:name, :image, :genres, :movie_id, :evaluation)
  end
end
