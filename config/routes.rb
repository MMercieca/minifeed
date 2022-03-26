Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :main_feeds
  post 'main_feed', to: 'main_feeds#create'
  get 'main_feed', to: 'main_feeds#show'

  match '/feeds/:identifier/:id', to: 'feeds#show', via: :get

  # Defines the root path route ("/")
  root "home#index"
end
