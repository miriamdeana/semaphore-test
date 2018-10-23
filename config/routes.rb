Rails.application.routes.draw do
  resources :calls, only: [:create]
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  
  mount ActionCable.server, at: '/cable'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  root to: 'welcome#home'

  namespace :zendesk do
    get 'users/search_results'
    get 'tickets/new'
  end
end
