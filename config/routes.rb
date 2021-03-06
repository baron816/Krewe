Rails.application.routes.draw do
  resources :users, except: :index do
    resources :messages, only: :create

    collection do
      get 'complete_sign_up'
      get 'verify_email'
      patch 'update_email'
    end

    member do
      get 'email_confirmed'
      get 'personal_messages'
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
      resources :messages, only: [:create, :index]
      member do
        post 'add_user'
        delete 'remove_user'
      end
    end
  end

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/get_started')
  delete 'logout' => 'sessions#destroy'
  post 'login' => 'sessions#login'

  resources :password_resets, except: [:get, :destroy]
  resources :newsletters, only: [:new, :create]
  resources :surveys, only: [:new, :create]

  get "get_started" => "home#landing"
  get "admin_dash" => "home#admin_dash"
  get "faq" => "home#faq"
  get "about" => "home#about"
  get "privacy_policy" => "home#privacy_policy"
  get "terms_of_service" => "home#terms_of_service"
  root 'users#show'

  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :update, :create] do
        resources :groups, only: [:index]
        member do
          get 'personal_messages'
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

  get "*any", via: :all, to: "errors#not_found"
end
