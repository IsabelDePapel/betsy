require "test_helper"

describe ProductsController do
  # routes: home, index, show, edit, delete, new, update, create
  let(:product) { products(:croissant) }
  let(:fake_product_id) { Product.last.id + 1 }
  let(:product_data) { {
    product: {
      name: "test",
      description: "testing",
      price: 1,
      quantity: 5,
      merchant_id: merchants(:one).id
    },
    categories_string:
      "cupcakes, scones"
  } }

  describe "not logged in" do
    before do
      # log in and then log out
      auth_user = merchants(:one)
      login(auth_user, :github)
      post logout_path
    end

    describe "index" do
      it "returns success" do
        # confirm logged out
        session[:user_id].must_be_nil

        get products_path
        must_respond_with :success
      end

      it "returns success when there are no products" do
        Product.destroy_all
        get products_path
        must_respond_with :success
      end
    end

    describe "show" do
      it "returns success if given a valid product id and product is visible" do
        product.visible = true
        product.save

        # confirm visibility
        product.reload.visible.must_equal true

        get product_path(product)
        must_respond_with :success
      end

      it "returns not found if given bogus product id" do
        get product_path(fake_product_id)
        must_respond_with :not_found
      end

      it "responds with redirect if product is not visible" do
        product.visible = false
        product.save

        # confirm visibility
        product.reload.visible.must_equal false
        get product_path(product)
        must_respond_with :redirect
      end
    end

    describe "add to cart" do
      it "creates a user and order if they don't exist and adds the item to a new cart" do
        # confirm logout
        session[:order_id].must_be_nil
        session[:user_id].must_be_nil

        num_users = User.count
        num_orders = Order.count
        num_items = OrderItem.count

        patch product_add_to_cart_path(product.id, {"quantity" => "4"})
        User.count.must_equal num_users + 1, "num users must be #{num_users + 1}"
        Order.count.must_equal num_orders + 1, "num orders must be #{num_orders + 1}"
        OrderItem.count.must_equal num_items + 1, "num orderitems must be #{num_items + 1}" # CRASHES

        session[:order_id].must_equal Order.last.id
        session[:user_id].must_equal User.last.id

        OrderItem.last.product.must_equal product

        must_respond_with :redirect
        must_redirect_to products_path
      end

      it "creates an order if doesn't exist and adds product to existing cart" do
        login(merchants(:one), :github)

        session[:order_id].must_be_nil
        session[:user_id].must_equal merchants(:one).id

        num_users = User.count
        num_orders = Order.count

        patch product_add_to_cart_path(product.id)

        User.count.must_equal num_users
        Order.count.must_equal num_orders + 1
        session[:order_id].must_equal Order.last.id
        must_respond_with :redirect
        must_redirect_to products_path
      end

      it "doesn't add item to cart if product id isn't valid and cart is empty" do
        num_items = OrderItem.count

        patch product_add_to_cart_path(fake_product_id)

        OrderItem.count.must_equal num_items
        Order.last.order_items.count.must_equal 0
      end

      it "increases the quantity if the same item is added to the cart" do
        num_items = OrderItem.count
        num = 3

        num.times do
          patch product_add_to_cart_path(product.id, {"quantity" => "1"})
        end

        OrderItem.count.must_equal num_items + 1
        OrderItem.last.quantity.must_equal 1
      end
    end # end of add to cart

    describe "remove from cart" do
      before do
        @start_count = OrderItem.count
        patch product_add_to_cart_path(product.id, {"quantity" => "2"})
      end

      it "deletes the order item from the order if item in cart" do
        OrderItem.count.must_equal @start_count + 1
        added_item = OrderItem.last

        patch remove_from_cart_path(added_item.id)

        OrderItem.count.must_equal @start_count
        OrderItem.last.wont_equal added_item

        must_respond_with :redirect
        must_redirect_to cart_path
      end

      it "deletes entire order item if qty > 1 if item in cart" do
        # add same item to increase qty
        num = 2

        num.times do
          # when you do patch,
          patch product_add_to_cart_path(product.id, {"quantity" => "2"})

        end

        added_item = OrderItem.last
        added_item.quantity.must_equal 2 # CRASHES

        patch remove_from_cart_path(added_item)

        OrderItem.count.must_equal @start_count
        OrderItem.last.wont_equal added_item
      end

      it "redirect and doesn't delete if order item doesn't exist" do
        patch remove_from_cart_path OrderItem.last.id + 1
        must_respond_with :redirect

        OrderItem.count.must_equal @start_count + 1 # bc prod added in before do # CRASHES

      end
      it "doesn't delete anything if order item isn't in the cart" do
        # cart_item = OrderItem.last
        not_in_cart = order_items(:pending)

        patch remove_from_cart_path(not_in_cart)

        OrderItem.count.must_equal @start_count + 1 # CRASHES
        OrderItem.find_by(id: not_in_cart.id).wont_be_nil
      end
    end


    # guest user not authorized for anything else related to products - it all redirects BACK
    describe "new (unauthorized)" do
      it "responds with redirect if guest user tries to create a product" do
        get new_product_path
        must_respond_with :redirect
      end
    end

    describe "create (unauthorized)" do
      it "responds with redirect if guest user tries to create a new product with valid data" do
        Product.new(product_data[:product]).must_be :valid?

        post products_path params: product_data

        must_respond_with :redirect
      end

      it "responds with redirect if guest user tries to create a new product with invalid data" do
        post products_path params: { product: { name: "" } }

        must_respond_with :redirect
      end
    end

    describe "edit (unauthorized)" do
      it "responds with redirect if guest user tries to edit a product that exists" do
        get edit_product_path(product)
        must_respond_with :redirect
      end

      it "responds with redirect if guest user tries to edit a product that doesn't exist" do
        get edit_product_path(fake_product_id)
        must_respond_with :redirect
      end
    end

    describe "update (unauthorized)" do
      it "responds with redirect if guest tries to update a product that exists with valid data" do
        before_product = product

        patch product_path product, params: product_data

        must_respond_with :redirect
        product.must_equal before_product
      end

      it "responds with redirect if guest tries to update a product with invalid data" do
        patch product_path product, params: { product: { quantity: -2 } }
        must_respond_with :redirect
      end

      it "responds with redirect if guest tries to update a product that doesn't exist" do
        patch product_path fake_product_id, params: product_data
        must_respond_with :redirect
      end
    end

    describe "destroy (unauthorized)" do
      it "responds with redirect if guest tries to delete a product" do
        start_count = Product.count

        delete product_path(product)

        must_respond_with :redirect
        Product.count.must_equal start_count
      end

      it "responds with redirect if guest tries to delete a product that doesn't exist" do
        delete product_path(fake_product_id)
        must_respond_with :redirect
      end
    end

    describe "change visibility" do
      it "responds with redirect if guest tries to hide/unhide a product" do
        current_vis = product.visible

        patch change_visibility_product_path(product)

        must_respond_with :redirect
        product.visible.must_equal current_vis
      end

      it "responds with redirect if guest tries to hide/unhide a product that doesn't exist" do
        patch change_visibility_product_path(fake_product_id)
        must_respond_with :redirect
      end
    end

  end # end of guest user tests

  describe "logged in" do
    let(:other_product) { products(:cupcake) } # non-auth product

    before do
      # log in
      @auth_user = merchants(:one)
      login(@auth_user, :github)
    end

    describe "index" do
      it "returns success" do
        # confirm logged in
        session[:user_id].must_equal @auth_user.user_id
        get products_path
        must_respond_with :success
      end
    end

    describe "show" do
      it "returns success when given a valid product id and product is visible" do
        product.visible = true
        product.save

        # confirm vis
        product.reload.visible.must_equal true

        get product_path(product)
        must_respond_with :success
      end

      it "returns success when given a product the merchant owns even if NOT currently visible" do
        product.visible = false
        product.save

        product.reload.visible.must_equal false

        get product_path(product)
        must_respond_with :success
      end

      it "responds with redirect when given another merchant's product that is NOT visible" do
        other_product.visible = false
        other_product.save

        other_product.reload.visible.must_equal false

        get product_path(other_product)
        must_respond_with :redirect
      end

      it "returns not found when given an invalid product id" do
        get product_path(fake_product_id)
        must_respond_with :not_found
      end
    end

    describe "new" do
      it "returns success" do
        get new_product_path
        must_respond_with :success
      end
    end

    describe "create" do
      it "creates product and redirects to products page when given valid data" do


        post products_path params: product_data
        must_respond_with :redirect
        must_redirect_to products_path
      end

      it "returns bad request when given invalid data" do
        post products_path params: { product: { name: "" } }
        must_respond_with :bad_request
      end
    end

    describe "edit" do
      it "returns success when given valid product id that belongs to the merchant" do
        get edit_product_path(product)
        must_respond_with :success
      end

      it "redirects to product page when given product id belonging to another merchant" do
        get edit_product_path(other_product)
        must_respond_with :redirect
        must_redirect_to products_path
      end

      it "returns not found when given invalid product id" do
        get edit_product_path(fake_product_id)
        must_respond_with :not_found
      end
    end

    describe "update" do
      it "returns success and updates when given valid data and product belongs to merchant" do
        start_count = Product.count

        patch product_path product, params: product_data

        must_respond_with :redirect
        must_redirect_to products_path
        Product.count.must_equal start_count

        product_data[:product].each do |attribute, val|
          product.reload[attribute].must_equal val, "#{attribute} should equal #{val}"
        end
      end

      it "returns bad request when given invalid data" do
        orig_name = product.name

        patch product_path product, params: { product: { name: "" } }

        must_respond_with :bad_request
        product.reload.name.must_equal orig_name
      end

      it "redirects to product page when it tries to update a product belonging to another merchant" do
        orig_name = other_product.name
        patch product_path other_product, params: { name: "calzone" }

        must_respond_with :redirect
        must_redirect_to products_path

        other_product.name.must_equal orig_name
      end
    end

    describe "destroy" do
      it "allows the merchant who sells the product to delete the product" do
        start_count = Product.count

        delete product_path(product)

        must_respond_with :redirect
        must_redirect_to products_path

        Product.count.must_equal start_count - 1
      end

      it "redirects to products path and doesn't delete if merchant tries to delete a product they don't sell" do
        start_count = Product.count

        delete product_path(other_product)

        must_respond_with :redirect
        must_redirect_to products_path

        Product.count.must_equal start_count
      end

      it "responds with not found if given invalid product id" do
        start_count = Product.count

        delete product_path(fake_product_id)

        must_respond_with :not_found
        Product.count.must_equal start_count
      end
    end

    describe "change visibility" do
      it "responds with success if a merchant changes the visibility of their products" do
        expected_vis = product.visible == true ? false : true

        patch change_visibility_product_path(product)
        must_respond_with :redirect
        must_redirect_to merchant_path(@auth_user.id)
        product.reload.visible.must_equal expected_vis
      end

      it "redirects if a merchant tries to change the visibility of a product they don't own" do
        # skip
        orig_vis = product.visible

        patch change_visibility_product_path(other_product)

        must_respond_with :redirect
        must_redirect_to products_path
        product.reload.visible.must_equal orig_vis
      end

      it "responds with not found if a merchant tries to change the visibility of a product that doesn't exist" do
        patch change_visibility_product_path(fake_product_id)

        must_respond_with :not_found
      end
    end
  end

end
