Rails.application.routes.draw do

  root 'products#home'
  # User here interpreted as someone who's buying
  # Have to be logged in to access these routes
  # Display order_items of things they ordrered
  resources :users do
    resource :orders do
      resource :order_items, only: [:index, :show]
    end
  end

  # Merchant here interpreted as someone who's selling
  # Display order_items that have products owned by them
  resources :merchants do
    resources :orders do
      resources :order_items
      # Billing info of their buyers
      resources :billings
    end
    # Products they own/are selling
    resources :products
  end

  patch '/merchants/:merchant_id/products/:id/change_visibility', to: 'products#change_visibility', as: 'change_visibility_product'

  resources :categories do
    resources :products
  end

  resources :products do

    post :add_to_cart, to: 'products#add_to_cart', as: 'add_to_cart'

    resources :reviews, only: [:show, :new, :create]

  end


  resources :orders, only: [:index, :show] do
    get 'confirmation', on: :member
    resources :billings, only: [:new, :create]
  end

  get '/cart', to: "orders#cart", as: 'cart'

  # directs non-valid pages to 404.html
  get '*path' => redirect('/404.html')

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
