Rails.application.routes.draw do
  resources :users

  resources :groups, only: [:index, :show] do
  	resources :messages, only: [:create]
  end

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get '/add_group' => 'users#add_group', :as => :add_group

  get '/groups/:id/drop' => 'groups#drop', :as => :drop

  root 'home#index'
end
