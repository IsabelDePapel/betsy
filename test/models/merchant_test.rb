require "test_helper"

describe Merchant do
  let(:merchant) { Merchant.new }
  let(:merchant1) {merchants(:merchant1)}
  let(:merchant2) {merchants(:merchant2)}

  describe "model relationships" do
    describe "belongs_to :user" do
      it "must have a user to be valid" do
        merchant1.valid?.must_equal true
        merchant1.user.must_be_kind_of User

        merchant1.user = nil
        merchant1.valid?.must_equal false
      end

      it "cannot have a user that belongs to another merchant" do
        merchant1.user = merchant2.user

        merchant1.valid?.must_equal false
      end

      it "can access its user data and modify it" do
        merchant1.user.must_be_kind_of User
        an_id = merchant1.user.id
        User.find(an_id).must_equal merchant1.user
      
      end

    end
  end #model relationships

  describe "validations" do
    #TODO validates :username, presence: true, uniqueness: { case_sensitive: false }
    #TODO validates :email, presence: true, uniqueness: { case_sensitive: false }
  end #validations
end
