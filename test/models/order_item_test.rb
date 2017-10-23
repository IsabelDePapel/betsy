require "test_helper"

describe OrderItem do
  let(:pending) { order_items(:pending) }
  let(:paid) { order_items(:paid) }

  describe "validations" do
    it "must have a quantity to be valid" do
      pending.valid?.must_equal true

      pending.quantity = nil
      pending.valid?.must_equal false
    end

    it "requires quantity to be an integer > 0" do
      invalid_qtys = [-1, 0, 1.5]

      valid_qtys = [1, 5]

      invalid_qtys.each do |qty|
        pending.quantity = qty
        pending.valid?.must_equal false, "#{qty} isn't a valid quantity"
      end

      valid_qtys.each do |qty|
        pending.quantity = qty
        pending.valid?.must_equal true, "#{qty} is a valid quantity"
      end
    end

    # do we want status to be required? we can add a different status
    # (e.g. cart) that won't display to merchant view
    it "requires status to be valid" do
      pending.valid?.must_equal true
      pending.status = nil

      pending.valid?.must_equal false
    end

    it "requires status to be either paid, pending, complete, or canceled" do
      invalid_statuses = ["shipped", "done", ""]

      invalid_statuses.each do |bad_status|
        pending.status = bad_status
        pending.valid?.must_equal false
      end

      OrderItem::STATUSES.each do |status|
        pending.status = status
        pending.valid?.must_equal true
      end
    end

    it "cannot add an order item if more than quantity" do
      # there are 10 macaroons
      macaroons = products(:macaroon)
      invalid_order_item = OrderItem.new(product: macaroons, order: orders(:two), quantity: 15)

      invalid_order_item.valid?.must_equal false
    end
  end

  describe "relations" do
    it "must belong to a product" do
      pending.valid?.must_equal true

      pending.must_respond_to :product
      pending.product.must_be_kind_of Product

      pending.product = nil
      pending.valid?.must_equal false
    end

    it "must belong to an order" do
      pending.valid?.must_equal true

      pending.must_respond_to :order
      pending.order.must_be_kind_of Order

      pending.order = nil
      pending.valid?.must_equal false
    end
  end

  describe "item_price" do
    it "returns the total price of an order item (qty * price)" do
      croissant = products(:croissant)
      expected_price = croissant.price * 2

      # pending has 2 croissants
      pending.price.must_equal expected_price
    end
  end

  describe "update_product_quantity" do
    let(:macaroons) { products(:macaroon) }
    let(:new_item) { OrderItem.new(order: orders(:two), product: macaroons, quantity: 8, status: "paid") }

    it "updates the product quantity if status is paid and item qty >= inventory" do
      # new_item = OrderItem.new(order: orders(:two), product: macaroons, quantity: 8, status: "paid")
      start_qty = macaroons.quantity
      new_item.update_product_quantity

      macaroons.quantity.must_equal (start_qty - new_item.quantity)
    end

    it "won't update quantity if status isn't paid" do
      start_qty = macaroons.quantity
      new_item.update_attribute(:status, "pending")

      # confirm change made
      new_item.status.must_equal "pending"

      new_item.update_product_quantity

      macaroons.quantity.must_equal start_qty
    end

    it "won't update quantity if not enough inventory" do
      new_item.update_attribute(:status, "paid")
      new_qty = 6
      macaroons.update_attribute(:quantity, new_qty)

      # confirm changes made
      macaroons.quantity.must_equal new_qty
      new_item.status.must_equal "paid"

      new_item.update_product_quantity

      macaroons.quantity.must_equal new_qty
    end
  end

end
