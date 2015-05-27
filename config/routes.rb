Rails.application.routes.draw do
  resources :users, except: [:index, :destroy] do
    get 'public_profile'
  end

  resources :groups, only: [:index, :show] do
  	resources :messages, only: [:create]
  end

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get '/add_group' => 'users#add_group', :as => :add_group

  get '/groups/:id/drop_user' => 'groups#drop_user', :as => :drop_user

  resources :personal_messages, only: [:create]

  root 'home#index'
end
