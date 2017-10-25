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

  describe "average_rating" do
    let(:seller) { Merchant.find_by(id: users(:one).id) }

    it "must return the average rating of a merchant based on product reviews" do
      # with only one review
      seller.average_rating.must_equal reviews(:croissant_review).rating.to_f

      # add review and confirm recalculates average
      new_review_data = {
        review: {
          user_id: users(:two).id,
          product_id: products(:macaroon).id,
          rating: 1,
          text: "test"
        }
      }
      Review.create!(new_review_data[:review])

      reviews = Review.select("*").joins(:product).where("products.merchant_id = ?", seller.id)

      expected_avg = ((reviews.sum { |review| review.rating }) / reviews.length.to_f).round(2)

      seller.reload.average_rating.must_equal expected_avg
    end

    it "must return nil if there are no reviews" do
      Review.destroy_all
      seller.average_rating.must_be_nil
    end

  end

  describe "revenue(stat)" do
    it "returns the total amount of order_items that have the status" do
      item_cost = products(:croissant).price
      merchant1.revenue("complete").must_equal (item_cost * 3)

      OrderItem.create(order: orders(:two), product: products(:croissant), quantity: 1, status: "complete")

      merchant1.revenue("complete").must_equal (item_cost * 4)
    end
  end

  describe "total_revenue" do
    it "returns the total amount of order_items that are paid and complete" do
      item_cost = products(:croissant).price
      merchant1.total_revenue.must_equal (item_cost * 3)

      new_item = OrderItem.create(order: orders(:two), product: products(:croissant), quantity: 1)

      merchant1.total_revenue.must_equal (item_cost * 3)

      new_item.status = "paid"
      new_item.save

      merchant1.total_revenue.must_equal (item_cost * 4)
    end
  end
end
