Rails.application.routes.draw do
  resources :users, except: [:index, :destroy] do
    member do
      get 'public_profile'
    end
  end

  resources :groups, only: [:show] do
    delete 'drop_user', on: :member
  	resources :messages, only: [:create]
    resources :drop_user_votes, only: [:create, :destroy]
    resources :expand_group_votes, only: [:create, :destroy]
  end

  resources :activities, except: [:index, :destroy] do
    member do
      post 'add_user'
      delete 'remove_user'
    end
  end

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :personal_messages, only: [:create]
  resources :password_resets, except: [:get, :destroy]
  resources :newsletters, only: [:new, :create]

  root 'home#index'
end
