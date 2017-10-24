require "test_helper"

describe Category do
  let(:category) { Category.new }
  let(:cupcakes) { categories(:cupcakes) }
  let(:cupcake) { products(:cupcake) }

  describe "has and belongs to many products" do
    it "can have 0, 1 or many products and can list its products" do
      cupcakes.products.count.must_equal 0
      cupcakes.products.must_equal []

      cupcakes.products << products(:cupcake)
      cupcakes.products.count.must_equal 1
      cupcakes.products.must_include products(:cupcake)

      cupcakes.products << products(:croissant)
      cupcakes.products.count.must_equal 2
      cupcakes.products.must_include products(:croissant) && products(:cupcake)
    end

    it "can access its products data" do
      cupcakes.products << cupcake
      cupcakes.products.first.name.must_equal "Chocolate Peanut Butter Cupcake"
    end
  end

  describe "validations" do
    it "must have a name to be valid" do
      category.valid?.must_equal false

      category.name = "something"
      category.valid?.must_equal true
    end
  end

  describe "existing_cat?" do
    it "returns true if it finds a category by it's own name" do
      valid_tag = cupcakes.name
      Category.existing_cat?(valid_tag).must_equal true
    end

    it "returns nil if it is not given a category name" do
      nonexistant_tags = ["jarjar binks", 8.5, 0, nil, :kiwi]

      nonexistant_tags.each do |item|
        Category.existing_cat?(item).must_be_nil
      end
    end
  end
end
