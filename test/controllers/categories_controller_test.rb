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

  describe "create" do
    it "should get create" do
      skip
      category_data = {
        category: {
          name: "a, list,,of,   tags, with multiple words,"
        }
      }
      #post categories_create, params category_data


    end

  end
end
