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

      order.change_status("paid")

      items.each do |item|
        item.reload
        item.status.must_equal "paid"
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

end
