Rails.application.routes.draw do

  devise_for :users
  
  root "pages#landing"
  
  resources :listings, only: [:index, :show]
  resources :bookmarks, only: [:create, :destroy, :index]
  resources :users, only: [:show, :edit, :update]
  
  # About page
  get 'about', to: 'pages#about'
  get 'landing', to: 'pages#landing'

  
  get 'chat', to: 'chats#show'
  post 'chat', to: 'chats#create'
  post 'chat/new_session', to: 'chats#new_session', as: :new_chat_session
  delete 'chat/:id', to: 'chats#destroy', as: :end_chat_session
  
  namespace :api do
    namespace :v1 do
      get 'base/status', to: 'base#status'
    end
  end
end
