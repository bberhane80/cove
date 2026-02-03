# config/routes.rb
Rails.application.routes.draw do
  devise_for :users

  root to: "listings#index"

  resources :listings, only: [:index, :show]
resources :bookmarks, only: [:create, :destroy, :index]
end
