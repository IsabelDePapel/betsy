require "test_helper"

describe OrderItemsController do
  let(:paid) { order_items(:paid) } # this is merch2
  let(:other_item) { order_items(:pending) } # this is merch1
  let(:fake_item_id) { OrderItem.last.id + 1 }

  describe "not logged in" do
    before do
      # log in and then log out
      auth_user = merchants(:two)
      login(auth_user, :google_oauth2)
      post logout_path
    end

    it "redirects back if guest tries to change status of an order item that exists" do
      session[:user_id].must_be_nil
      orig_status = paid.status

      patch change_status_path paid, status: "canceled"

      paid.reload.status.must_equal orig_status
      must_respond_with :redirect

    end

    it "redirects back if guest tries to change status of an order item that doesn't exist" do
      patch change_status_path fake_item_id, status: "complete"

      must_respond_with :redirect
    end
  end

  describe "logged in" do
    before do
      # log in and then log out
      @auth_user = merchants(:two)
      login(@auth_user, :google_oauth2)
    end

    describe "change_status" do
      it "changes the status if the item belongs to the merchant" do
        session[:user_id].must_equal @auth_user.id

        new_status = "complete"

        patch change_status_path paid, status: new_status

        paid.reload.status.must_equal new_status
        must_respond_with :redirect
      end

      it "updates inventory if status is changed to canceled" do
        start_count = paid.product.quantity

        patch change_status_path paid, status: "canceled"

        paid.reload.status.must_equal "canceled"
        paid.product.quantity.must_equal start_count + paid.quantity
      end

      it "returns not found if item doesn't exist" do
        patch change_status_path fake_item_id, status: "complete"
        must_respond_with :not_found
      end

      # is there a way to test this?? How can you make sure the merchant doesn't exist???
      it "returns not found if merchant doesn't exist" do
        skip
        patch change_status_path paid, status: "canceled"
        must_respond_with :not_found
      end

      it "responds with redirect if item belongs to another merchant" do
        orig_status = other_item.status
        other_item.product.merchant_id.wont_equal @auth_user.id

        patch change_status_path other_item, status: "complete"

        other_item.reload.status.must_equal orig_status
        must_respond_with :redirect
      end
    end
  end


end
