Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  get 'sign_in', to: 'sessions#new'
  get '/sign_out', to: 'sessions#destroy'

  resources :videos, only: [:show] do
    collection do
      get :search, to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  resources :users, only:[:create, :show]
  resources :relationships, only: [:create, :destroy]
  get 'people', to: 'relationships#index'

  resources :categories, only: [:show]
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :destroy]
  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'

  resources :password_resets, only: [:create, :edit, :update]
  get '/forgot_password', to: 'password_resets#new'
  get '/password_reset_confirmation', to: 'password_resets#confirm'
  get '/expired_token', to: 'pages#expired_token'

  resources :invitations, only: [:new, :create]
  resources :charges, only: [:new, :create]

  namespace :admin do
    resources :videos, only: [:new, :create]
  end
end
