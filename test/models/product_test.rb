require "test_helper"

describe Product do
  let(:product) { products(:croissant) }

  describe "#valid?" do

    it "should belong to a merchant" do
      product.valid?.must_equal true
      product.merchant = nil
      product.valid?.must_equal false
    end

    it "can have multiple order items" do
      expected_items = OrderItem.where(product_id: product.id)
      product.order_items.count.must_equal expected_items.count
    end

    it "should return false if it doesn't have a name" do
      product.name = nil
      product.valid?.must_equal false
    end

    it "should return false if price is invalid" do
      # no price
      product.price = nil
      product.valid?.must_equal false

      # invalid price
      product.price = "NOT A PRICE"
      product.valid?.must_equal false

      product.price = 123
      product.valid?.must_equal true
    end

    it "should return false if it doesn't have a boolean for visibility" do
      product.visible = nil

      product.valid?.must_equal false
    end

    it "should return false if quanitity's invalid" do
      product.quantity = nil
      product.valid?.must_equal false

      product.quantity = -1
      product.valid?.must_equal false

      product.quantity = 0
      product.valid?.must_equal true
    end
  end

  describe "in_stock?" do
    it "must return true if product is in stock (qty > 0)" do
      product.valid?.must_equal true
      product.in_stock?.must_equal true

      product.quantity = 0
      product.in_stock?.must_equal false
    end
  end


  describe "average_rating" do
    it "returns the average rating of a product" do
      # croissant review of 5
      new_rating = 2
      Review.create!(user: User.create, product: product, rating: new_rating, text: "more croissants")
      num_reviews = Review.where(product: product).count

      expected_rating = ((new_rating + reviews(:croissant_review).rating) / num_reviews.to_f).round(1)

      product.average_rating.must_equal expected_rating

    end

    it "returns nil if there are no reviews" do
      Review.destroy_all

      product.average_rating.must_be_nil
    end
  end

  describe "add_category" do
    it "adds a category to a product" do
      start_cat = product.categories.length
      product.add_category("cupcakes")

      product.categories.length.must_equal start_cat + 1
    end
  end

  describe "populate_categories" do
    before do
      @cupcakes = categories(:cupcakes)
      @input = "--a, list,,of,   tags, with multiple words,,\"ugly\"--,"
      @clean = ["a", "list", "of", "tags", "with multiple words", "ugly"]

    end

    it "takes a list of categories and adds new categories to product" do
      proc { product.populate_categories(@input) }.must_change 'product.categories.length', @clean.length

      @clean.each do |tag|
        product.categories.must_include Category.find_by(name: tag)
      end
    end

    it "takes a list of categories and doesn't add already existing categories" do
      product.categories << @cupcakes

      proc { product.populate_categories("cupcakes") }.must_change 'product.categories.length', 0

      product.categories.must_equal [@cupcakes]
    end

    it "removes categories when they aren't included upon update" do
      product.populate_categories(@input + ","+ @cupcakes.name)
      no_tags = product.categories.count

      product.populate_categories(@input)
      product.categories.count.must_equal (no_tags - 1)


      @clean.each do |tag|
        product.categories.must_include Category.find_by(name: tag)
      end

      product.categories.wont_include @cupcakes
    end
  end

  describe "num_sold" do
    it "returns the total number sold of a given product" do
      # get total croissants sold
      total_croissants = 0

      OrderItem.all.each do |item|
        if item.product == product
          total_croissants += item.quantity
        end
      end

      product.num_sold.must_equal total_croissants
    end
  end
end
