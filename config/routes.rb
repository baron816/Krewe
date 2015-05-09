Rails.application.routes.draw do
  resources :users

  resources :groups, only: [:index, :show] do
  	resources :messages, only: [:create]
  end

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  root 'users#index'
end
