Rails.application.routes.draw do

  # User here interpreted as someone who's buying
  # Have to be logged in to access these routes
  # Display order_items of things they ordrered
  resources :users do
    resource :orders do
      resource :order_items, only: [:index, :show]
    end

    # Their own billing info (as a buyer)
    resources :billings
  end

  # Merchant here interpreted as someone who's selling
  # Display order_items that have products owned by them
  resources :merchants do
    resources :orders do
      resources :order_items

      # Billing info of their buyers
      resources :billings
    end
    #/merchants/:merchant_id/products/:id(.:format)
    patch '/merchants/:merchant_id/products/:id/change_visibility', to: 'products#change_visibility', as: 'change_visibility_work'

    # Products they own/are selling
    resources :products

  end

  resources :categories do
    resources :products
  end

  resources :products do
    resources :reviews
  end

  # directs non-valid pages to 404.html
  get '*path' => redirect('/404.html')

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
