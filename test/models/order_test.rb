require "test_helper"

describe Order do
  let(:order) { orders(:one) }
  let(:completed_order) { orders(:three) }

  describe "relations" do
    it "can access order_items and its data" do
      completed_order_item = order_items(:complete)
      completed_order.order_items.must_equal completed_order_item

    end
  end

end
