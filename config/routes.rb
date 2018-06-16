Rails.application.routes.draw do
  resource :orders, only: [:new, :create]
  get 'orders', to: 'orders#index'
  get 'dashboard', to: 'dashboard#index'

  devise_for :users, path: 'auth', path_names: { 
    sign_in: 'login', 
    sign_out: 'logout', 
    password: 'secret', 
    confirmation: 'verification', 
    unlock: 'unblock', 
    registration: 'register', 
    sign_up: 'signup' 
  }
  
  root 'landing#index'
end
