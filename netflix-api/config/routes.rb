Rails.application.routes.draw do
  root 'sessions#create'

  post 'sign_up' => 'users#create'
  post 'login' => 'sessions#create'
  delete 'sign_out' => 'sessions#destroy'

  resources :users do
    post :add_wish
    post :evaluation
    get :list_wisheds
    put :remove_list_wisheds
    resources :movies
  end
end
