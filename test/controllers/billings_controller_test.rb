require "test_helper"

describe BillingsController do
  let(:valid_order_id) { orders(:one).id }
  let(:invalid_order_id) { Order.last.id + 1}
  let(:new_order_id) { Order.create!(user: users(:one)).id }

  describe "new" do
    it "should return success if given a valid order id" do
      get new_order_billing_path(valid_order_id)

      must_respond_with :success
    end

    it "should return bad request if given invalid order id" do
      get new_order_billing_path(invalid_order_id)

      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "create" do
    # TEMP will redirect to order confirmation page
    it "should redirect to home page if billing created" do
      billing_data = {
        billing: {
          order_id: new_order_id,
          name: "foo bar",
          email: "foo@bar.com",
          street1: "11 main st",
          city: "springfield",
          state_prov: "IL",
          zip: "99999",
          country: "USA",
          ccnum: "4444444444444444",
          ccmonth: 10,
          ccyear: 2018
        }
      }

      start_count = Billing.count

      post order_billings_path( new_order_id ), params: billing_data

      Billing.count.must_equal start_count + 1
      must_respond_with :redirect

      # TEMP
      must_redirect_to root_path

    end

    it "should change all order item status from pending to paid if billing created" do

    end

    it "should redirect to home page if given invalid order id" do
      billing_data = {
        billing: {
          order_id: invalid_order_id,
          name: "foo bar",
          email: "foo@bar.com",
          street1: "11 main st",
          city: "springfield",
          state_prov: "IL",
          zip: "99999",
          country: "USA",
          ccnum: "4444444444444444",
          ccmonth: 10,
          ccyear: 2018
        }
      }

      start_count = Billing.count

      post order_billings_path( invalid_order_id ), params: billing_data

      Billing.count.must_equal start_count
      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "should return bad request if given invalid data" do
      bad_billing_data = {
        billing: {
          order_id: valid_order_id,
          name: "name"
        }
      }

      start_count = Billing.count

      post order_billings_path( new_order_id ), params: bad_billing_data

      Billing.count.must_equal start_count
      must_respond_with :bad_request
    end

  end

end
