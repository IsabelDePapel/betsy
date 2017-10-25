require "test_helper"

describe BillingsController do
  let(:valid_order_id) { orders(:one).id }
  let(:invalid_order_id) { Order.last.id + 1}
  let(:new_order) { Order.create!(user: users(:one))}

  describe "new" do
    it "should return success if given a valid order id" do
      get new_order_billing_path(valid_order_id)

      must_respond_with :success
    end

    it "should return bad request if given invalid order id" do
      get new_order_billing_path(invalid_order_id)

      must_respond_with :redirect
      must_redirect_to products_path
    end

    it "should redirect to products page if order has no order items" do
      OrderItem.destroy_all

      get new_order_billing_path(valid_order_id)

      must_respond_with :redirect
      must_redirect_to products_path
    end
  end

  describe "create" do
    let(:billing_data) { {
      billing: {
        name: "foo bar",
        email: "foo@bar.com",
        street1: "11 main st",
        city: "springfield",
        state_prov: "IL",
        zip: "99999",
        country: "USA",
        ccnum: "4444444444444444",
        ccmonth: 10,
        ccyear: 2018,
        cvv: 222
      }
    } }

    it "should redirect to confirmation page if billing created and change status to paid" do
      # add items to order
      OrderItem.create!(product: products(:croissant), order: new_order, quantity: 2, status: "pending")
      OrderItem.create!(product: products(:cupcake), order: new_order, quantity: 1, status: "pending")

      new_order.order_items.each do |item|
        item.status.must_equal "pending"
      end

      start_count = Billing.count

      post order_billings_path(new_order.id), params: billing_data

      # confirm status changed to paid
      new_order.order_items.each do |item|
        item.reload.status.must_equal "paid"
      end

      Billing.count.must_equal start_count + 1
      must_respond_with :redirect
      must_redirect_to confirmation_order_path(new_order)
    end

    it "should redirect to cart path, not create billing, and keep status as pending if not enough inventory" do
      # new_order = Order.find(new_order_id)
      OrderItem.create!(product: products(:croissant), order: new_order, quantity: 2, status: "pending")
      OrderItem.create!(product: products(:cupcake), order: new_order, quantity: 1, status: "pending")

      # change croissant inventory to 1
      new_order.order_items.each do |item|
        if item.product.name == "Croissant"
          item.product.quantity = 1
          item.product.save
          # confirm change
          item.reload
          item.product.quantity.must_equal 1
        end
      end

      # change status to paid
      new_order.order_items.each do |item|
        item.update_attribute(:status, "paid")
      end

      start_count = Billing.count

      post order_billings_path( new_order ), params: billing_data

      # confirm status still pending
      new_order.order_items.each do |item|
        item.reload.status.must_equal "pending"
      end

      Billing.count.must_equal start_count

      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "should redirect to home page if given invalid order id" do

      start_count = Billing.count

      post order_billings_path( invalid_order_id ), params: billing_data

      Billing.count.must_equal start_count
      must_respond_with :redirect
      must_redirect_to products_path
    end

    it "should return bad request if given invalid data" do
      # create order items for the order
      OrderItem.create!(product: products(:croissant), order: new_order, quantity: 2)
      OrderItem.create!(product: products(:cupcake), order: new_order, quantity: 1)

      bad_billing_data = {
        billing: {
          name: "name"
        }
      }

      start_count = Billing.count

      post order_billings_path( new_order ), params: bad_billing_data

      Billing.count.must_equal start_count
      must_respond_with :bad_request
    end

  end

end
