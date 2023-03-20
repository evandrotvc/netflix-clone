class MovieController < ApplicationController
  before_action :authorize_request, except: %i[new create]
  before_action :set_user,
    only: %i[show edit update destroy add_wish list_wisheds evaluation
             remove_list_wisheds]

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
    # UserList.find_by(movie_id: movie.id, user_id: @user.id)&.update(wished: false)

    render json: { message: 'Movie removed to your list' }, status: :ok
  end

  def evaluation
    movie = Movie.find_by(name: movie_params[:name])
    movie = Movie.create!(movie_params) if movie.blank?

    user_list = UserList.find_by(movie_id: movie.id,
      user_id: @user.id)&.update(evaluation: params[:evaluation])

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
