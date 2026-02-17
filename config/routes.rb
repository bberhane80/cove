Rails.application.routes.draw do
  devise_for :users
  
  root 'listings#index'
  
  resources :listings, only: [:index, :show]
  resources :bookmarks, only: [:create, :destroy, :index]
  resources :users, only: [:show, :edit, :update]
  
  # About page
  get 'about', to: 'pages#about'
  
  # Health check
  get '/health', to: 'health#index'
end
