require "test_helper"

describe Billing do
  let(:bridget) { billings(:bridget) }

  describe "validations" do
    it "must have a name" do
      bridget.valid?.must_equal true

      bridget.name = nil
      bridget.valid?.must_equal false
    end

    it "must have an email" do
      bridget.email = nil
      bridget.valid?.must_equal false
    end

    it "must have a street1" do
      bridget.street1 = nil
      bridget.valid?.must_equal false
    end

    it "must have a city" do

    end

    it "must have a state/prov" do

    end

    it "must have a zip" do

    end

    # do we want to make this default to USA?
    it "must have a country" do

    end

    it "must have a ccnum" do

    end

    it "must have a ccyear" do

    end

    it "does not require street2 to be valid" do

    end
  end

  describe "relations" do

  end
end
