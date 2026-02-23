Rails.application.routes.draw do

  devise_for :users
  
  root "pages#landing"
  
  resources :listings, only: [:index, :show]
  resources :bookmarks, only: [:create, :destroy, :index]
  resources :users, only: [:show, :edit, :update]
  
  # About page
  get 'about', to: 'pages#about'
  get 'landing', to: 'pages#landing'
  
  # Health check
  get '/health', to: 'health#index'
  
  # ...existing routes...
  
  namespace :api do
    namespace :v1 do
      get 'base/status', to: 'base#status'
    end
  end
end
