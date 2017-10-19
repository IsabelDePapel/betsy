require "test_helper"

describe User do
  let(:user) { users(:one) } # merchant one is also user one
  let (:user_no_merchant)  { users(:three) }

  describe "validations" do
    it "doesn't require any info other than id" do
      user.valid?.must_equal true
    end

  end

  describe "relations" do

    describe "has one merchant" do
      it "can access merchant data" do
        user.must_respond_to :merchant
        user.merchant.must_equal merchants(:one)
      end

      it "doesn't require a merchant to be valid" do

        # confirm it has no merchants
        user_no_merchant.merchant.must_be_nil
        user_no_merchant.valid?.must_equal true
      end
    end

    describe "has one billing" do
      it "can access billing info" do
        user.must_respond_to :billing
        user.billing.must_equal billings(:bridget)
      end

      # it "can't have more than one billing" do
      #   new_billing_data = {
      #     user_id: user.id,
      #     name: "new name",
      #     email: "new@name.com",
      #     street1: "11 test street",
      #     city: "Nome",
      #     state_prov: "AK",
      #     zip: "85710",
      #     country: "USA",
      #     ccnum: "4444444444444444",
      #     ccmonth: 10,
      #     ccyear: 2018
      #   }
      #
      #   extra_billing = Billing.new(new_billing_data)
      #   extra_billing.valid?.must_equal false

      end
    end
  end

end
