require "test_helper"

describe OrdersController do

  describe "confirmation" do
    it "returns success" do
      order_two = orders(:two)
      get confirmation_order_path(order_two)
      must_respond_with :success
    end
  end

  describe "confirmation" do
    it "returns success" do
      order_two = orders(:two)
      get confirmation_order_path(order_two)
      must_respond_with :success
    end
  end

  describe "confirmation" do
    it "returns success" do
      order_two = orders(:two)
      get confirmation_order_path(order_two)
      must_respond_with :success
    end
  end
end
