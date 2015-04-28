Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
<<<<<<< HEAD
  get '/home', to: 'videos#index'

  resources :videos, only: [:show]
  resources :categories, only: [:show]
=======
>>>>>>> 9d77871a2d32d3ea4b83fcdd4cba61a1386af970
end
