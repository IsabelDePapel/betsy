require "test_helper"

describe Billing do
  let(:billing) { Billing.new }

  it "must be valid" do
    value(billing).must_be :valid?
  end
end
