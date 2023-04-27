Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end
  ActiveAdmin.routes(self)

  get 'patreon_launch', to: 'patreon#patreon_launch'
  get 'patreon_callback', to: 'patreon#patreon_callback'
  
  resources :main_feeds do
    post 'main_feed', to: 'main_feeds#create'
    get  'main_feed', to: 'main_feeds#show'
  end

  resources :mini_feeds do
    post  'mini_feed', to: 'mini_feeds#create'
    patch 'mini_feed', to: 'mini_feeds#update'
    get   'mini_feed', to: 'mini_feed#show'
  end

  get 'known_feed', to: 'known_feeds#show'
  get 'register', to: 'home#register'
  get 'dashboard', to: 'home#dashboard'
  get 'privacy', to: 'home#privacy'
  get 'legal', to: 'home#legal'
  get 'terms', to: 'home#terms'
  get 'about', to: 'home#about'
  get 'contact', to: 'home#contact'
  post 'send_feedback', to: 'home#send_feedback'
  get 'error', to: 'home#error'

  match '/feeds/:identifier/delete', to: 'main_feeds#delete', via: :get
  match '/feeds/:identifier/:id/listen', to: 'mini_feeds#listen', via: :get
  match '/feeds/:identifier/setup_known_feed', to: 'known_feeds#setup_known_feed', via: :get
  match '/feeds/:identifier/:id', to: 'feeds#show', via: :get
  match '/check', to: 'check#show', via: :get
  match '/check/results', to: 'check#results', via: :post
  match '/check/results', to: 'check#show', via: :get
  
  # Defines the root path route ("/")
  root "home#home"
end
