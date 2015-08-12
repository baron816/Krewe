Rails.application.routes.draw do
  resources :users, except: [:index, :destroy] do
    member do
      get 'public_profile'
      post 'add_group'
    end
  end

  resources :groups, only: [:show] do
    delete 'drop_user', on: :member
  	resources :messages, only: [:create]
    resources :drop_user_votes, only: [:create, :destroy]
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

  root 'home#index'

  namespace :api do
    namespace :v1 do
      resources :users, except: [:index, :destroy] do
        get 'public_profile', on: :member
      end
    end
  end
end
