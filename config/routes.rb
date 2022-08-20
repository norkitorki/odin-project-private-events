Rails.application.routes.draw do
  devise_for :users

  resources :users, only: :show
  
  resources :events do
    resources :event_invitations, except: %i[ index edit update ]
    resources 'attendees', only: %i[ index create ]
    delete 'attendees', to: 'attendees#destroy'
  end
  
  root 'events#index'

  get 'user/invitations', to: 'users#invitations', as: :user_invitations
  get 'search/', to: 'search#show', as: :search
end
