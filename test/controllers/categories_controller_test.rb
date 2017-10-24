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

  it "should get show" do
    skip
    get categories_show_url
    value(response).must_be :success?
  end

  it "should get create" do
    skip
    get categories_create_url
    value(response).must_be :success?
  end

end
