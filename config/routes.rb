Rails.application.routes.draw do
  resources :users

  resources :groups, only: [:index, :show]

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  root 'users#index'
end
