Rails.application.routes.draw do
  resources :users, except: [:index, :destroy] do
    member do
      get 'public_profile'
      post 'join_group'
    end
  end

  resources :groups, only: [:show] do
    delete 'drop_user', on: :member
    resources :drop_user_votes, only: [:create, :destroy]
    resources :expand_group_votes, only: [:create, :destroy]
    resources :activities, except: [:index, :destroy] do
      member do
        post 'add_user'
        delete 'remove_user'
      end
    end
  end


  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :messages, only: [:create]
  resources :password_resets, except: [:get, :destroy]
  resources :newsletters, only: [:new, :create]

  root 'home#index'
  get "*any", via: :all, to: "errors#not_found"

  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :update, :create] do
        member do
          get 'public_profile'
          post 'add_group'
        end
      end

      resources :groups, only: :show do
        delete 'drop_user', on: :member
      end

      resources :activities, only: [:create, :update, :show] do
        member do
          post 'add_user'
          delete 'remove_user'
        end
      end

      resources :sessions, only: [:create, :destroy]
    end
  end
end
