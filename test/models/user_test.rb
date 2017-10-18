require "test_helper"

describe User do
  let(:user) { User.new }

  describe "validations" do
    # it "doesn't require any info other than id" do
    #   user.valid?.must_equal true
    #
    #   user_with_info = users(:one)
    #   user_with_info.valid?.must_equal true
    #
    #   user_with_info.name = nil
    #   user_with_info.valid?.must_equal true
    #
    #   user_with_info.email = nil
    #   user_with_info.valid?.must_equal true
    #
    #   user_with_info.street1 = nil
    #   user_with_info.valid?.must_equal true
    #
    #   user_with_info.street2 = nil
    #   user_with_info.valid?.must_equal true
    #
    #   user_with_info.state_prov = nil
    #   user_with_info.valid?.must_equal true
    #
    #   user_with_info.zip = nil
    #   user_with_info.valid?.must_equal true
    #
    #   user_with_info.ccnum = nil
    #   user_with_info.valid?.must_equal true
    #
    #   user_with_info.ccmonth = nil
    #   user_with_info.valid?.must_equal true
    #
    #   user_with_info.ccyear = nil
    #   user_with_info.valid?.must_equal true

    # end

    # it "require credit card month to be an integer between 1 and 12" do
    #   # if we allow nil, this will accept nil and empty string as valid months
    #   # when we do form input for billing info, if ccmonth isn't a required field
    #   # then we'll run into errors. Farm this out into a different model???
    #   invalid_months = ["cat", 1.5, -2, 13, 0]
    #   valid_months = (1..12).to_a
    #
    #   user = users(:one)
    #
    #   valid_months.each do |month|
    #     user.ccmonth = month
    #     user.valid?.must_equal true, "#{month} is a valid month"
    #   end
    #
    #   invalid_months.each do |month|
    #     user.ccmonth = month
    #     user.valid?.must_equal false, "#{month} is an invalid month"
    #   end
    #
    # end

  end

  describe "relations" do
  end
end
