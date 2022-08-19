Rails.application.routes.draw do
  devise_for :users
  resources :users, only: :show do 
    get 'invitations', to: 'users#invitations'
  end
  
  root 'events#index'

  get 'users/:id', to: 'users#show', as: :user
  get 'events/:id/attendees', to: 'events#attendees', as: :event_attendees
  get 'search/', to: 'search#show', as: :search
end
