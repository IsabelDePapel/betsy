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
end
