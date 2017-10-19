require "test_helper"

describe Category do
  let(:category) { Category.new }
  let(:cupcakes) { categories(:cupcakes) }

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
      
    end
  end

  describe "validations" do
    it "must have a name to be valid" do
      category.valid?.must_equal false

      category.name = "something"
      category.valid?.must_equal true
    end
  end
end
