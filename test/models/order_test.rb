require "test_helper"

describe Order do
  let(:order) { orders(:one) }
  let(:completed_order) { orders(:two) }

  let(:croissant_total) { order_items(:pending).price }
  let(:cupcake_total) { order_items(:paid).price }

  describe "relations" do
    it "must have a user to be valid" do
      order.valid?.must_equal true

      order.user = nil
      order.valid?.must_equal false
    end

    it "can set user through users/user id" do
      expected_id = users(:one).id

      order.user_id.must_equal expected_id

      # IDEA: WISHLIST - prevent this from happening
      order.user = users(:two)
      order.valid?.must_equal true
    end

    it "has one billing" do
      # only one relationship tested in billing
      order.must_respond_to :billing
      order.billing.must_equal billings(:bridget)
    end

    it "has many order items" do
      order.must_respond_to :order_items
      order.order_items.must_equal [order_items(:pending), order_items(:paid)]

    end

    it "cacade deletes order items" do
      start_count = OrderItem.count
      num_items = order.order_items.length

      order.destroy

      OrderItem.count.must_equal start_count - num_items
    end

    it "cascade deletes billing" do
      billing_id = billings(:bridget).id

      order.destroy

      Billing.find_by(id: billing_id).must_be_nil
    end

    it "has many products through order_items" do
      order.must_respond_to :products
    end
  end

  describe "change_status" do
    it "must change the status of all its order_items" do
      items = order.order_items

      # confirm status not what it's being changed to
      items.each do |item|
        item.status.wont_equal "complete"
      end

      order.change_status("complete")

      items.each do |item|
        item.reload.status.must_equal "complete"
      end
    end

    it "won't change the status if given invalid status" do
      items = order.order_items

      order.change_status("cat")

      items.each do |item|
        item.status.wont_equal "cat"
      end
    end
  end

  describe "update_inventory" do
    before do
      @before_qtys = {} # tracks qtys before update

      order.order_items.each do |item|
        @before_qtys[item.product.name] = item.product.quantity
      end
    end

    it "will return empty hash and update the product inventory using order item quantity if status is paid" do

      # croissant is pending; cupcake is paid
      order.update_inventory.must_equal Hash.new

      order.order_items.each do |item|
        if item.status == "paid"
          item.product.quantity.must_equal (@before_qtys[item.product.name] - item.quantity)
        else
          item.product.quantity.must_equal @before_qtys[item.product.name]
        end
      end
    end

    it "will return a hash with item name and inventory and rollback status to pending if not enough inventory" do
      # change croissant inventory to 1
      @before_qtys["Croissant"] = 1

      # change all order item status to paid
      order.order_items.each do |item|
        # change croissant inventory to 1
        if item.product.name == "Croissant"
          item.product.quantity = 1
          item.product.save
        end

        item.update_attribute(:status, "paid")
      end

      # confirm status changed to paid
      order.order_items.each do |item|
        item.reload.status.must_equal "paid"
      end

      error = order.update_inventory
      error.must_be_kind_of Hash
      error[:name].must_equal "Croissant"

      order.order_items.each do |item|
        item.reload.status.must_equal "pending"
        item.product.quantity.must_equal @before_qtys[item.product.name]
      end

    end

  end

  describe "price" do
    it "calculates the price of all order items in the order" do
      # order has 2 croissants (3.50) and 1 cupcake (4.00)
      expected_total = 11.0
      # confirm subtotals calculating
      (croissant_total + cupcake_total).must_equal expected_total

      order.price.must_equal (croissant_total + cupcake_total)
    end
  end

  describe "tax" do
    it "calculates the tax for the entire order" do
      expected_tax = (croissant_total + cupcake_total) * Order::TAX

      order.tax.must_equal expected_tax
    end
  end

  describe "total" do
    it "calculates the order total (price + tax) for the entire order" do
      subtotal = croissant_total + cupcake_total
      tax = subtotal * Order::TAX

      order.total.must_equal (subtotal + tax)
    end
  end

  describe "change_user(new_user_id)" do
    it "changes the user to the user_id passed in" do
      old_user = order.user
      new_user = users(:two)
      order.change_user(new_user.id)

      order.user.wont_equal old_user
    end
  end

  describe "find_last_cart(merch_user_id)" do
    it "returns nil if the user has no orders" do
      new_user = User.new
      Order.find_last_cart_id(new_user.id).must_be_nil
    end

    it "returns the id of the last order if it was pending and nil if the last order wasn't pending" do
      user4 = users(:four)
      order4_id = Order.find_last_cart_id(user4.id)
      order4 = Order.find(order4_id)
      order4.must_equal orders(:four)

      order4.change_status("paid")
      Order.find_last_cart_id(user4.id).must_be_nil
    end
  end

  describe "add_product_to_order" do
    let(:no_order_item) { orders(:three) }
    let(:product){ products(:croissant)}

    it "returns true if it adds a product to the order if it doesn't exist in the order yet" do
      start_oi_count = no_order_item.order_items.count

      no_order_item.add_product_to_order(product).must_equal true
      no_order_item.order_items.count.must_equal start_oi_count + 1
    end

    it "returns true if it adds to the quantity of a product that's in the order" do
      start_oi_count = no_order_item.order_items.count
      puts "start_oi_count: #{start_oi_count}"

      no_order_item.add_product_to_order(product)
      # no_order_item.reload # hey order item, go to the database, download latest info and update no_order_item to get the lastest attribute values
      no_order_item.add_product_to_order(product).must_equal true
      no_order_item.order_items.count.must_equal start_oi_count + 1
    end

    it "returns false if it user tries to add an invalid product in order" do
      no_order_item.add_product_to_order(nil).must_equal false
    end

    it "returns false if it adds a valid product in a non-cart order" do
      order.add_product_to_order(products(:croissant)).must_equal false
    end
  end

  describe "remove_order_item_from_order" do
    let(:has_order_items) { orders(:four) }
    let(:has_paid_items) { orders(:five) }

    it "returns true if it successfully removes an order item from the order" do
      has_order_items.remove_order_item_from_order(order_items(:for_add_to_cart1)).must_equal true
    end

    it "returns false if order item passed is invalid" do
      has_order_items.remove_order_item_from_order(order_items(:for_add_to_cart1))
      # should return false because it was just deleted
      has_order_items.reload
      has_order_items.remove_order_item_from_order(order_items(:for_add_to_cart1)).must_equal false

      # should return false for an order_item passed that belongs to a non-cart order
      has_paid_items.remove_order_item_from_order(order_items(:paid_item1)).must_equal false

    end

    it "returns false if order item passed in is not in cart" do
      # doesn't belong to this order
      other_start_oi_count = orders(:two).order_items.count
      self_start_oi_count = has_order_items.order_items.count

      has_order_items.remove_order_item_from_order(order_items(:other_order_item)).must_equal false

      orders(:two).order_items.count.must_equal other_start_oi_count
      has_order_items.order_items.count.must_equal self_start_oi_count
    end
  end

  describe "is_cart?" do
    let(:has_order_items) { orders(:four) }
    let(:has_paid_items) { orders(:five) }

    it "returns true if every order_item in order has a status of 'pending'" do
      has_order_items.is_cart?.must_equal true
    end

    it "returns false if there is an order_item with a status that's not 'pending'" do
      has_paid_items.is_cart?.must_equal false
    end
  end

end
