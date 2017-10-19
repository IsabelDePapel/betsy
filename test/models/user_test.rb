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

      it "has many reviews" do
        user.must_respond_to :reviews
        user.reviews.must_equal [reviews(:cupcake_review)]
      end

      it "cascade nullifies" do
        user.destroy
        merchants(:one).user_id.must_be_nil
        reviews(:cupcake_review).user_id.must_be_nil
      end
    end

  end
end
