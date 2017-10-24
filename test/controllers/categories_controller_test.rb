require "test_helper"

describe CategoriesController do
  describe "index" do
    it "succeeds when there are categories" do
      Category.count.must_be :>, 0, "No categories in the test fixtures"
      get categories_path
      must_respond_with :success
    end

    it "succeeds when there are no works" do
      Category.destroy_all
      get categories_path
      must_respond_with :success
    end
  end

  describe "create" do #TODO Move me to products.rb!!
    it "" do
      skip
      category_data = {
        category: {
          name: "A, lIst,,of,   tags, with MULTIPLE words,"
        }
      }
      #post categories_create, params category_data


    end

  end
end
