Rails.application.routes.draw do
  resources :calls, only: [:create]
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'welcome#home'
end
