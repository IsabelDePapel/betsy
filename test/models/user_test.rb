require "test_helper"

describe User do
  let(:user) { users(:one) }

  describe "validations" do
    it "doesn't require any info other than id" do
      user.valid?.must_equal true
    end

  end

  describe "relations" do
  end
end
