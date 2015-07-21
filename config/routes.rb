Rails.application.routes.draw do
  resources :users, except: [:index, :destroy] do
    get 'public_profile', on: :member
    post 'add_group', on: :member
  end

  resources :groups, only: [:show] do
    delete 'drop_user', on: :member
  	resources :messages, only: [:create]
    resources :drop_user_votes, only: [:create, :destroy]
  end

  resources :activities, except: [:index, :destroy] do
    post 'add_user', on: :member
    delete 'remove_user', on: :member
  end

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :personal_messages, only: [:create]
  resources :password_resets, except: [:get, :destroy]

  root 'home#index'
end
