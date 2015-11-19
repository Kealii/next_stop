Rails.application.routes.draw do
  root 'welcome#index'

  resources :routes, only: [:index, :show]

  get '/near_by', to: 'welcome#near_by'
  get '/auth/twitter', as: :login
  get '/auth/twitter/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: :logout
end
