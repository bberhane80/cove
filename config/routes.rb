# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  
  root 'listings#index'
  
  resources :listings do
    member do
      post 'bookmark'
      delete 'unbookmark'
    end
    collection do
      get 'search'
    end
  end
  
  resources :bookmarks, only: [:index]
  
  # JSON API endpoints
  namespace :api do
    namespace :v1 do
      resources :listings, only: [:index, :show]
    end
  end
end
