Rails.application.routes.draw do
  resources :calls, only: [:create]
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  
  require 'sidekiq/web'
  mount Sidekiq::Web => "/sidekiq"
  root to: 'welcome#home'
end
