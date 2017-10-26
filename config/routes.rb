Rails.application.routes.draw do

  get 'order_items/change_status'

  root 'products#home'

  # ======= USERS - Unnecessary to have Controller

  # ======= SESSIONS
  get '/auth/:provider/callback', to: 'sessions#create', as: 'callback'

  get '/login', to: 'sessions#login', as: 'login'
  post '/logout', to: 'sessions#logout', as: 'logout'

  # ======= MERCHANTS
  resources :merchants, only: [:index, :show]

  # patch 'merchants/:merchant_id/order_items/:order_item_id/change_status', to: 'merchants#change_item_status', as: 'change_status'

  # ======= PRODUCTS
  resources :products, except: [:update] do
    resources :reviews, only: [:new, :create]
    patch :add_to_cart, to: 'products#add_to_cart', as: 'add_to_cart'
  end
  patch 'products/:id', to: 'products#update'

  patch 'products/:id/change_visibility', to: 'products#change_visibility', as: 'change_visibility_product'

  get 'merchants/:merchant_id/products', to: 'products#index', as: 'merchant_products'

  get 'categories/:category_id/products', to: 'products#index', as: 'category_products'

  post 'products/:product_id/categories', to: 'categories#create'

  # ======= CATEGORIES
  resources :categories, only: [:index, :create]

  # ======= ORDER ITEMS - Unnecessary to have Controller
  patch 'order_items/:id/change_status', to: 'order_items#change_status', as: 'change_status'
  # ======= ORDERS
  resources :orders, only: [:index, :show] do
    get 'confirmation', on: :member
    resources :billings, only: [:new, :create]
  end

  get 'merchants/:merchant_id/orders/:order_id', to: 'orders#show', as: 'merchant_order'

  get '/cart', to: "orders#cart", as: 'cart'
  patch '/cart/:order_item_id/remove_from_cart', to: "products#remove_from_cart", as: 'remove_from_cart'
  patch '/cart/:order_item_id/update_quantity', to: "products#update_quantity_in_cart", as: 'update_quantity_in_cart'

  # ======= REVIEWS
  resources :reviews, only: [:show, :edit, :update, :destroy]

  # ======= OTHER
  # directs non-valid pages to 404.html
  get '*path' => redirect('/404.html')

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
