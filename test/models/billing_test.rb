require "test_helper"

describe Billing do
  let(:billing) { Billing.new }
  let(:bridget) { billings(:bridget) } #ALL FIXTURES ARE VALID


  describe "validations" do
    it "must have a all fields except street2 to be valid" do
      all_req_fields = [:name, :email, :street1, :city, :state_prov, :zip, :country, :ccnum, :ccmonth, :ccyear]

      bridget.valid?.must_equal true

      all_req_fields.each do |field|
        bridget[field] = nil
        bridget.valid?.must_equal false
        bridget.reload
      end
    end

    it "will still be valid without field street2" do
      bridget.street2.wont_be_nil
      bridget.street2 = nil
      bridget.valid?.must_equal true
    end

    it "will not be valid if CC month is not an integer between 1 & 12" do
      invalid_months = ["cat", 1.5, -2, 13, 0]
      valid_months = (1..12).to_a

      valid_months.each do |month|
        bridget.ccmonth = month
        bridget.valid?.must_equal true, "#{month} should be a valid month"
      end

      invalid_months.each do |month|
        bridget.ccmonth = month
        bridget.valid?.must_equal false, "#{month} shoudn't be a valid month"
      end
    end
  end

  describe "relations" do
    describe "belongs to order" do
      it "must have an order to be valid" do
        bridget.order = nil
        bridget.valid?.must_equal false
      end

      it "must be able to access its order's data" do
        expected_id = orders(:one).id
        bridget.order.id.must_equal expected_id
      end
    end

  end
end
