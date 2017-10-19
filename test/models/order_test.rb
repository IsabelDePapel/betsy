require "test_helper"

describe Order do
  let(:order) { orders(:one) }
  let(:completed_order) { orders(:two) }

  describe "relations" do
    it "must have a user to be valid" do
      order.valid?.must_equal true

      order.user = nil
      order.valid?.must_equal false
    end

    it "can set user through users/user id" do
      expected_id = users(:one).id

      order.user_id.must_equal expected_id

      # WISHLIST - prevent this from happening
      # TODO
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

end
