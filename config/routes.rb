Rails.application.routes.draw do

  root 'products#home'

  # ======= USERS - Unnecessary to have Controller

  # ======= SESSIONS
  get '/auth/:provider/callback', to: 'sessions#create', as: 'callback'

  get '/login', to: 'sessions#login', as: 'login'
  post '/logout', to: 'sessions#logout', as: 'logout'

  # ======= MERCHANTS
  resources :merchants, except: [:new, :edit, :update, :destroy] #login methods may change required routes

  # ======= PRODUCTS
  resources :products, except: [:update] do
    resources :categories, except: [:new, :destroy]
    resources :reviews, only: [:new, :create]
  end
  patch 'products/:id', to: 'products#update'

  patch 'products/:id/change_visibility', to: 'products#change_visibility', as: 'change_visibility_product'

  # ======= ORDER ITEMS - Unnecessary to have Controller

  # ======= ORDERS
  resources :orders, only: [:index, :show] do
    get 'confirmation', on: :member
    resources :billings, only: [:new, :create]
  end
  get '/cart', to: "orders#cart", as: 'cart'
  get '/cart/:order_item_id/remove_from_cart', to: "orders#remove_from_cart", as: 'remove_from_cart'

  # ======= REVIEWS
  resources :reviews, only: [:show, :edit, :update, :destroy]

  # ======= OTHER
  # directs non-valid pages to 404.html
  get '*path' => redirect('/404.html')

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
