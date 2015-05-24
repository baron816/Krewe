Rails.application.routes.draw do
  resources :users, except: [:index, :destroy]

  resources :groups, only: [:index, :show] do
  	resources :messages, only: [:create]
  end

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get '/add_group' => 'users#add_group', :as => :add_group

  get '/groups/:id/drop' => 'groups#drop', :as => :drop

  get 'users/:id/public_profile' => 'users#public_profile', :as => :public_profile

  root 'home#index'
end
