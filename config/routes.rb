Rails.application.routes.draw do
  get 'user/show'
  devise_for :users
  resources :events

  root 'events#index'
end
