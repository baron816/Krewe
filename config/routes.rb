Rails.application.routes.draw do
  resources :users, except: [:index, :destroy] do
    get 'public_profile'
    get 'add_group'
  end

  resources :groups, only: [:show] do
    get 'drop_user'
  	resources :messages, only: [:create]
  end

  resources :activities, only: [:create] do
    get 'add_user'
  end

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :personal_messages, only: [:create]

  root 'home#index'
end
