# config/routes.rb
Rails.application.routes.draw do
  devise_for :users

  root to: "listings#index"

resources :users, only: [:show, :edit, :update]
resources :listings, only: [:index, :show]
resources :bookmarks, only: [:create, :destroy, :index]
end
