Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end
  ActiveAdmin.routes(self)
  
  resources :main_feeds
  post 'main_feed', to: 'main_feeds#create'
  get 'main_feed', to: 'main_feeds#show'
  get 'register', to: 'home#register'
  get 'dashboard', to: 'home#dashboard'

  match '/feeds/:identifier/:id', to: 'feeds#show', via: :get

  # Defines the root path route ("/")
  root "home#home"
end
