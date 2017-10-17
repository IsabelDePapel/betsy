require "test_helper"

describe Merchant do
  let(:merchant) { Merchant.new }

  describe "model relationships" do
    #TODO belongs_to :user
    it "belongs to a user" do

    end
  end #model relationships

  describe "validations" do
    #TODO validates :username, presence: true, uniqueness: { case_sensitive: false }
    #TODO validates :email, presence: true, uniqueness: { case_sensitive: false }
  end #validations
end
