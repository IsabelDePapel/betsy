require "test_helper"

describe ProductsController do
  # routes: home, index, show, edit, delete, new, update, create
  let(:product) { products(:croissant) }

  describe "General Tests" do
    it "renders 404 not_found for a bogus product ID" do
      fake_product_id = Product.last.id + 1
      get edit_work_path(fake_product_id)
      must_respond_with :not_found
    end

    it "successfully gets home page" do
      get root_path
      must_respond_with :success
    end
  end

  describe "Guest User Relations (not User model, browsing user)" do
    it "Allows guest users to view a list of products" do
      get products_path

      must_respond_with :success
    end

    it "Allows guest users to view a specific product's information" do
      get products_path(product.id)
      must_respond_with :success
    end

    it "Does not allow guest users to edit a product" do
      get edit_product_path(product.id)
      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "Does not allow guest users to change visibility of a product" do
      # needs change_visibility route in product
      # merchants/:merchant_id/products/:product_id/change_visibility
      puts "NOT DONE"
    end

    it "Does not allow guest users to create new product" do
      get new_product_path
      must_respond_with :redirect
    end
  end

  describe "Merchant Relations" do
    let(:merchant) { merchants(:one) }
    it "Allows Merchants to edit a product" do
      # Create login(user) helper in test_helper.rb
      login(merchant)

      get edit_product_path(product.id)
      must_respond_with :success
    end

    it "Allows a Merchant to change the visibility of a product" do
      # can't go to a product's show page nor see it index if it's invisible
      # needs change_visibility route in product
      # merchants/:merchant_id/products/:product_id/change_visibility
      puts "NOT DONE"
    end

    it "Allows a Merchant to create a new product" do
      login(merchant)

      proc {
        post products_path, params: { work: {
          name: "Cakepops",
          price: 3.67,
          description: "Cakepops stolen from Starbucks",
          photo_url: "http://s3.amazonaws.com/dccpost/Cake+Pops+/cake-pop-one.jpg",
          quantity: 1,
          visible: false}  }
      }.must_change 'Merchant.products.count', 1

      must_respond_with :redirect, "must redirect to the work's show page after creation"

    end
  end

end
