Rails.application.routes.draw do
  root "homes#top"
  get "homes/top"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get "home/about", to: "homes#about", as: "homes_about"

  resources :groups, only: [:index, :show, :new, :create, :edit, :update] do
    resource :group_user, only: [:create, :destroy]
    resource :notice, only: [:new, :create], controller: 'notices'
  end

  resources :books do
    resource :favorite, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
    resource :review, only: [:create]
  end

  get "/users/new", to: redirect("/users/sign_up")
  get '/users/sign_up', to: 'users#new', as: 'sign_up'
  resources :users, only: [:new, :create, :index, :show, :edit, :update] do
    resource :relationship, only: [:create, :destroy]
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
      resources :messages, only: [:index, :create]
      get "books_on_date", on: :member
  end
  resource :session, only: [:new, :create, :destroy]
  resources :passwords, param: :token
  get "search" => "searches#search", as: "search"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
