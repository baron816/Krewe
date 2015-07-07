Rails.application.routes.draw do
  resources :users, except: [:index, :destroy] do
    get 'public_profile'
    post 'add_group'
  end

  resources :groups, only: [:show] do
    delete 'drop_user'
  	resources :messages, only: [:create]
    resources :drop_user_votes, only: [:create, :destroy]
    resources :activities, only: [:create, :show, :new] do
      post 'add_user'
    end
  end

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :personal_messages, only: [:create]

  root 'home#index'
end
