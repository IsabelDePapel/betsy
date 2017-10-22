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

      it "cannot have a user that belongs to another merchant (unique user_id)" do
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
        merchant1.products.count.must_equal 2
        merchant1.products.must_include products(:croissant) && products(:macaroon)

        Product.destroy_all
        merchant1.valid?.must_equal true
        merchant1.products.count.must_equal 0
      end

      it "can access its products data" do
        prod_name = products(:cupcake).name
        merchant2.products[0].name.must_equal prod_name
      end
    end

    it "will cascade nullify" do
      merchant1.destroy
      products(:croissant).merchant_id.must_be_nil
    end
  end #model relationships
  #
  describe "validations" do
    it "must have a username to be valid" do
      blank_names = [nil, "", "   "]
      merchant1.valid?.must_equal true

      blank_names.each do |blank|
        merchant1.username = blank
        merchant1.valid?.must_equal false
      end
    end

    it "must have a unique username (case insensitive)" do
      dup_name = merchant1.username
      merchant2.valid?.must_equal true

      merchant2.username = dup_name
      merchant2.valid?.must_equal false

      dup_name_caps = dup_name.upcase
      dup_name_caps.wont_equal dup_name

      merchant2.username = dup_name_caps
      merchant2.valid?.must_equal false
    end

    it "must have an email to be valid" do
      blank_emails = [nil, "", "   "]
      merchant1.valid?.must_equal true

      blank_emails.each do |blank|
        merchant1.email = blank
        merchant1.valid?.must_equal false
      end
    end

    it "must have a unique email (case insensitive)" do
      dup_email = merchant1.email
      merchant2.valid?.must_equal true

      merchant2.email = dup_email
      merchant2.valid?.must_equal false

      dup_email_caps = dup_email.upcase
      dup_email_caps.wont_equal dup_email

      merchant2.email = dup_email_caps
      merchant2.valid?.must_equal false
    end

    it "must reject emails with invalid format" do
      valid_emails = %w(user@example.com foo@bar.net hello@world.edu MR_rogers.pbs@pbs.org M.ary_b3rry@bbc.co.uk)

      invalid_emails = %w(user.com foo@bar hello@world,edu mrrogers@pbs..org maryberry@bbc_co.uk)

      valid_emails.each do |email|
        merchant1.email = email
        merchant1.valid?.must_equal true
      end

      invalid_emails.each do |email|
        merchant1.email = email
        merchant1.valid?.must_equal false
      end
    end

  end #validations
end
