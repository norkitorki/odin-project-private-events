Rails.application.routes.draw do
  get 'user/show'
  devise_for :users
  resources :events

  root 'events#index'
  get 'events/:id/attendees', to: 'events#attendees', as: :event_attendees
end
