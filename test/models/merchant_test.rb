require "test_helper"

describe Merchant do
  let(:merchant) { Merchant.new }
  let(:merchant1) {merchants(:one)}
  let(:merchant2) {merchants(:two)}

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

      it "can access its user data" do
        an_id = merchant1.user.id
        User.find(an_id).must_equal merchant1.user
      end
    end

    describe "has many products" do
      it "can have 0 or many products and can list its products" do
        puts merchant1.products
        merchant1.products.length.must_equal 2
        merchant1.products.must_include products(:croissant) && products(:macaroon)

        products.destroy_all
        merchant1.valid?.must_equal true
        merchant1.products.must_equal []
      end

      it "can access its products data" do
        merchant1.products << cupcake
        merchant1.products.first.name.must_equal "Chocolate Peanut Butter Cupcake"
      end
    end
  end #model relationships
  #
  describe "validations" do
    #TODO validates :username, presence: true, uniqueness: { case_sensitive: false }
    #TODO validates :email, presence: true, uniqueness: { case_sensitive: false }
  end #validations
end
