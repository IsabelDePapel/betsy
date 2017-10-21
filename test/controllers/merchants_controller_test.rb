require "test_helper"

describe MerchantsController do
  it "should get index" do
    get merchants_index_path
    value(response).must_be :success?
  end

  it "should get show" do
    get merchant_show_url
    value(response).must_be :success?
  end

  it "should get edit" do
    get edit_merchant_path(merchant.id)
    value(response).must_be :success?
  end

  it "should get delete" do
    get merchant_delete_url
    value(response).must_be :success?
  end

  it "should get new" do
    get merchant_new_url
    value(response).must_be :success?
  end

  it "should get update" do
    get merchant_update_url
    value(response).must_be :success?
  end

  it "should get create" do
    get merchant_create_url
    value(response).must_be :success?
  end

end
