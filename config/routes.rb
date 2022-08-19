Rails.application.routes.draw do
  devise_for :users

  resources :users, only: :show do 
    get 'invitations', to: 'users#invitations'
  end
  
  resources :events do
    resources :event_invitations, except: %i[ index edit update ]
    get 'attendees', to: 'events#attendees'
  end
  
  root 'events#index'

  get 'search/', to: 'search#show', as: :search
end
