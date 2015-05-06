Rails.application.routes.draw do
  resources :users

  resources :groups, only: [:index, :show]
end
