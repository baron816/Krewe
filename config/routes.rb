Rails.application.routes.draw do
  resources :users, except: [:index] do
    resources :messages, only: :create
    member do
      get 'public_profile'
      post 'join_group'
    end
  end

  resources :groups, only: [:show] do
    delete 'drop_user', on: :member
    resources :drop_user_votes, only: [:create, :destroy]
    resources :expand_group_votes, only: [:create, :destroy]
    resources :topics, shallow: true, only: [:show, :create] do
      resources :messages, only: :create
      get 'change', on: :member
    end
    resources :activities, shallow: true, except: [:index] do
      resources :messages, only: :create
      member do
        post 'add_user'
        delete 'remove_user'
      end
    end
  end

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'


  resources :password_resets, except: [:get, :destroy]
  resources :newsletters, only: [:new, :create]
  resources :surveys, only: [:new, :create]

  get "beta_signup" => "beta_codes#new"
  post "beta_signup" => "beta_codes#create"

  root 'home#index'
  get "admin_dash" => "home#admin_dash"
  get "faq" => "home#faq"
  get "privacy_policy" => "home#privacy_policy"
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
        resources :activities, only: [:create, :update, :show] do
          member do
            post 'add_user'
            delete 'remove_user'
          end
        end
      end


      resources :messages, only: :create
      resources :sessions, only: [:create, :destroy]
    end
  end
end
