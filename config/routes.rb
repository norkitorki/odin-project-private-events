Rails.application.routes.draw do
  devise_for :users

  root 'events#index'

  resources :users, only: :show
  
  resources :events do
    resources :invitations, controller: :event_invitations, except: %i[ edit update ]
    resources :attendees, only: %i[ index create ]
    delete :attendees, to: 'attendees#destroy'
  end

  get 'user/invitations', to: 'users#invitations', as: :user_invitations
  get 'search/', to: 'search#show', as: :search
end
