require "test_helper"

describe Review do
  let(:review1) { reviews(:cupcake_review) }

  describe "model relationships" do

    it "must have a user to be valid" do
      review1.valid?.must_equal true

      review1.user = nil
      review1.valid?.must_equal false

    end

    it "must have a product to be valid" do
      review1.product = nil
      review1.valid?.must_equal false

      review1.product = products(:cupcake)
      review1.valid?.must_equal true
    end

  end

  describe "validations" do
    it "requires a rating to be valid" do
      blank_ratings = [nil, "", "   "]

      blank_ratings.each do |blank|
        review1.rating = blank
        review1.valid?.must_equal false, "#{blank} is not a valid rating"
      end
    end

    it "rating must be an integer between 1 and 5" do
      invalid_ratings = [-1, 1.5, 0, 6, "cat"]

      invalid_ratings.each do |invalid|
        review1.rating = invalid
        review1.valid?.must_equal false, "#{invalid} is not a valid rating"
      end
    end

    # this doesn't work if user isn't logged in
    # i.e. new user can just review whatever they want
    it "doesn't allow a merchant to review their own products" do
      # merchant is two
      review1.user = users(:two)
      review1.valid?.must_equal false

      review1.user = users(:one)
      review1.valid?.must_equal true
    end
  end

end
