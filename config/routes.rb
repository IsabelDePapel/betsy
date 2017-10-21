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
    end
    #/merchants/:merchant_id/products/:id(.:format)
    patch '/merchants/:merchant_id/products/:id/change_visibility', to: 'products#change_visibility', as: 'change_visibility'

    # Products they own/are selling
    resources :products

  end

  ##IDEA: Let's just activate the routes we need as we need them so we can trime the list of routes down a bit as we're working. I'm starting with trimming down categories/products nested situation
  resources :categories, only: [:show] do
    resources :products, only: [:index]
  end

  resources :products do
    resources :reviews, only: [:index, :new, :create]
  end

  resources :reviews, only: [:show, :edit, :update]

  resources :orders, only: [:index, :show] do
    get 'confirmation', on: :member
    resources :billings, only: [:new, :create]
  end

  # directs non-valid pages to 404.html
  get '*path' => redirect('/404.html')

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
