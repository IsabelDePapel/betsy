require "test_helper"

describe Product do
  let(:product) { products(:croissant) }

  describe "#valid?" do

    it "should belong to a merchant" do
      product.valid?.must_equal true
      product.merchant = nil
      product.valid?.must_equal false
    end

    it "should return false if it doesn't have a name" do
      product.name = nil
      product.valid?.must_equal false
    end

    it "should return false if price is invalid" do
      # no price
      product.price = nil
      product.valid?.must_equal false

      # invalid price
      product.price = "NOT A PRICE"
      product.valid?.must_equal false

      product.price = 123
      product.valid?.must_equal true
    end

    it "should return false if it doesn't have a boolean for visibility" do
      product.visible = nil

      product.valid?.must_equal false
    end

    it "should return false if quanitity's invalid" do
      product.quantity = nil
      product.valid?.must_equal false

      product.quantity = -1
      product.valid?.must_equal false

      product.quantity = 0
      product.valid?.must_equal true
    end
  end

  describe "#order_items" do
    it "can have multiple order items" do
      expected_items = OrderItem.where(product_id: product.id)
      product.order_items.count.must_equal expected_items.count
    end

    it "can add an order item" do
      another_product = products(:cupcake)
      newOrderItem = OrderItem.new(status: "pending", quantity: 2)
      newOrderItem.order = orders(:one)
      another_product.order_items << newOrderItem
      another_product.valid?.must_equal true
    end

    it "subtracts the quantity ordered from the product's inventory quantity" do
      skip # TEST THIS LATER TODO
      another_product = products(:cupcake)
      start_quantity = another_product.quantity # 5
      newOrderItem = OrderItem.new(status: "paid", quantity: 3)
      newOrderItem.order = orders(:one)

      another_product.order_items << newOrderItem
      another_product.quantity.must_equal start_quantity - newOrderItem.quantity
    end

    it "should return false if you order item's quantity is more than the available product quantity" do
      another_product = products(:macaroon)
      start_product_order_item_count = another_product.order_items.count # 0
      start_quantity = another_product.quantity # 10
      newOrderItem = OrderItem.new(status: "pending", quantity: 11)
      newOrderItem.order = orders(:one)

      # Tried to put OrderItem in, it shouldn't be able to
      another_product.order_items << newOrderItem
      # Shouldn't have added another OrderItem
      another_product.order_items.count.must_equal start_product_order_item_count
      # Shouldn't have subtracted from starting quantity
      another_product.quantity.must_equal start_quantity
    end

  end

  describe "in_stock?" do
    it "must return true if product is in stock (qty > 0)" do
      product.valid?.must_equal true
      product.in_stock?.must_equal true

      product.quantity = 0
      product.in_stock?.must_equal false
    end
  end
end
