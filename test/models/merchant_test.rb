require "test_helper"

describe Merchant do
  let(:merchant) { Merchant.new }
  let(:merchant1) {merchants(:merchant1)}

  describe "model relationships" do
    #TODO belongs_to :user
    it "belongs to a user" do
      merchant1.valid?.must_equal true

      merchant1.user = nil
      merchant1.valid?.must_equal false
    end
  end #model relationships

  describe "validations" do
    #TODO validates :username, presence: true, uniqueness: { case_sensitive: false }
    #TODO validates :email, presence: true, uniqueness: { case_sensitive: false }
  end #validations
end
