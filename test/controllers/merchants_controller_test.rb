require "test_helper"

describe MerchantsController do
  let(:merchant) { merchants(:two) } # google
  let(:other_merchant) { merchants(:one) }
  let(:fake_merch_id) { Merchant.last.id + 1 }

  describe "not logged in" do
    before do
      # log in and then log out
      auth_user = merchants(:two)
      login(auth_user, :google_oauth2)
      post logout_path
    end

    describe "index" do
      it "should return success for all users" do
        get merchants_path
        must_respond_with :success
      end

      it "should return success if no merchants" do
        Merchant.destroy_all
        get merchants_path
        must_respond_with :success
      end
    end

    # all the other methods are UNAUTHORIZED for guest users
    describe "show (unauth)" do
      it "should redirect back if user tries to view merchant account page" do
        get merchant_path(merchant)
        must_respond_with :redirect
      end

      it "responds with redirect if user tries to view acct page for merchant that doesn't exist" do
        get merchant_path(fake_merch_id)
        must_respond_with :redirect
      end
    end

    # describe "edit (unauth)" do
    #   it "should respond with redirect if user tries to edit merchant account page" do
    #     get edit_merchant_path(merchant)
    #     must_respond_with :redirect
    #   end
    #
    #   it "respond with redirect if user tries to edit acct page for merchant that doesn't exist" do
    #     get edit_merchant_path(fake_merch_id)
    #     must_respond_with :redirect
    #   end
    # end

  end # end of guest testing

  describe "logged in" do
    before do
      # log in and then log out
      @auth_user = merchants(:two)
      login(@auth_user, :google_oauth2)
    end

    describe "index" do
      it "should respond with success" do
        get merchants_path
        must_respond_with :success
      end
    end

    describe "show" do
      it "should respond with success if the merchant tries to view their own acct details page" do
        get merchant_path(merchant)
        must_respond_with :success
      end

      it "should respond with success if there are no products" do
        Product.destroy_all

        get merchant_path(merchant)
        must_respond_with :success
      end

      it "should respond with success if there are no order items" do
        OrderItem.destroy_all

        get merchant_path(merchant)
        must_respond_with :success
      end

      it "should respond with redirect if the merchant tries to view another merchant's acct details page" do
        get merchant_path(other_merchant)
        must_respond_with :redirect
      end

      it "should respond with not found if merchant tries to view acct page for merchant that doesn't exist" do
        get merchant_path(fake_merch_id)
        must_respond_with :not_found
      end
    end
  end

end
