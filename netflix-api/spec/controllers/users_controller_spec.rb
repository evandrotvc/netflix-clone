require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Warden::Test::Helpers
  include Devise::Test::ControllerHelpers

  let(:valid_attributes) do
    {
      name: 'evandro',
      password: '1234',
      email: 'evandro@gmail.com'
    }
  end

  let(:invalid_attributes) do
    {
      Name: 'evandro',
      email: 'evandro@gmail.com'
    }
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      let(:do_request) do
        post :create, params: { user: valid_attributes }, as: :json
      end

      it 'creates a new User' do
        expect { do_request }.to change(User, :count).by(1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      let(:do_request) do
        post :create, params: { user: invalid_attributes }, as: :json
      end

      it 'does not create a new User' do
        do_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end


  describe 'POST /add_wish' do
    let!(:user) { create(:user) }
    let(:movie_params) do
      {
        name: 'The last of us',
        movie_id: '1234',
        image: 'youtube/last_of_us',
        genres: 'Drama, Adventure'
      }
    end

    context 'with valid parameters' do
      let(:do_request) do
        post :add_wish, params: { user_id: user.id, movie: movie_params }, as: :json
      end

      it 'user likes no login' do
        do_request
        expect(response).to have_http_status(:unauthorized)
      end

      it 'user likes a movie' do
        login(user)
        expect { do_request }.to change(Movie, :count).by(1)
        .and change(UserList, :count).by(1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'invalid same movie to user' do
      let!(:movie) { create(:movie) }
      let!(:user_lists) { create(:user_list, user: user, movie: movie, wished: true) }

      let(:movie_params) do
        {
          name: movie.name,
          movie_id: movie.movie_id,
          image: 'youtube/last_of_us',
          genres: 'Drama, Adventure'
        }
      end

      let(:do_request) do
        post :add_wish, params: { user_id: user.id, movie: movie_params }, as: :json
      end

      it 'must to raise exception record unique' do
        login(user)

        expect { do_request }
        .to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe 'GET /list_wisheds' do
    context 'with valid parameters' do
      let!(:user) { create(:user) }
      let!(:user_lists) { create(:user_list, user: user) }
      let!(:user_lists2) { create(:user_list, user: user) }
      let(:do_request) do
        get :list_wisheds, params: { user_id: user.id }, as: :json
      end

      it 'user likes no login' do
        do_request
        expect(response).to have_http_status(:unauthorized)
      end

      it 'user likes a movie' do
        login(user)
        do_request
        expect(response).to have_http_status(:ok)
      end
    end
  end


  describe 'POST /evaluation' do
    let!(:user) { create(:user) }
    let(:movie_params) do
      {
        name: 'The last of us',
        movie_id: '1234',
        image: 'youtube/last_of_us',
        genres: 'Drama, Adventure'
      }
    end

    context 'with valid parameters' do
      let(:do_request) do
        post :evaluation, params: { user_id: user.id, movie: movie_params, evaluation: 'like' }, as: :json
      end

      it 'user likes no login' do
        do_request
        expect(response).to have_http_status(:unauthorized)
      end

      it 'user likes a movie' do
        login(user)
        expect { do_request }.to change(Movie, :count).by(1)
        .and change(UserList, :count).by(1)
        expect(response).to have_http_status(:ok)
        expect(UserList.last.evaluation).to eq('like')
      end
    end

    context 'deslike in movie' do
      let!(:movie) { create(:movie) }
      let!(:user_lists) { create(:user_list, user: user, movie: movie, evaluation: 'like') }

      let(:movie_params) do
        {
          name: movie.name,
          movie_id: movie.movie_id,
          image: 'youtube/last_of_us',
          genres: 'Drama, Adventure'
        }
      end

      let(:do_request) do
        post :evaluation, params: { user_id: user.id, movie: movie_params, evaluation: 'dislike' }, as: :json
      end

      it 'user deslike a movie' do
        login(user)
        do_request
        expect { user_lists.reload }.to change(user_lists, :evaluation).from('like').to('dislike')

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PUT /remove_wish_movie' do
    let!(:user) { create(:user) }
    let!(:movie) { create(:movie) }
    let!(:movie2) { create(:movie) }
    let!(:movie3) { create(:movie) }
    let!(:user_lists) { create(:user_list, user: user, movie: movie, evaluation: 'like', wished: true) }
    let!(:user_lists2) { create(:user_list, user: user, movie: movie2, evaluation: 'dislike', wished: true) }
    let!(:user_lists3) { create(:user_list, user: user, movie: movie3, evaluation: 'like') }


    context 'with valid parameters' do
      let(:do_request) do
        put :remove_list_wisheds, params: { user_id: user.id, movie_id: movie.movie_id }, as: :json
      end

      it 'user likes no login' do
        do_request
        expect(response).to have_http_status(:unauthorized)
      end

      it 'user likes a movie' do
        login(user)
        do_request
        expect { user_lists.reload }.to change(user_lists, :wished).from(true).to(false)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
