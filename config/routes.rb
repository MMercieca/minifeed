Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end
  ActiveAdmin.routes(self)
  
  resources :main_feeds do
    post 'main_feed', to: 'main_feeds#create'
    get  'main_feed', to: 'main_feeds#show'
  end

  resources :mini_feeds do
    post  'mini_feed', to: 'mini_feeds#create'
    patch 'mini_feed', to: 'mini_feeds#update'
  end

  get '/feeds/:identifier/:id', to: 'mini_feeds#edit'
  match '/feeds/:identifier/episodes/:id', to: 'mini_feeds#show', via: :get
  
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

  match '/feeds/:identifier/setup_known_feed', to: 'known_feeds#setup_known_feed', via: :get
  match '/feeds/:identifier/:id', to: 'feeds#show', via: :get
  
  # Defines the root path route ("/")
  root "home#home"
end
