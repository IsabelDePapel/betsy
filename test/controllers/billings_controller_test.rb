require "test_helper"

describe BillingsController do
  it "should get index" do
    get billings_index_url
    value(response).must_be :success?
  end

  it "should get show" do
    get billings_show_url
    value(response).must_be :success?
  end

  it "should get edit" do
    get billings_edit_url
    value(response).must_be :success?
  end

  it "should get delete" do
    get billings_delete_url
    value(response).must_be :success?
  end

  it "should get new" do
    get billings_new_url
    value(response).must_be :success?
  end

  it "should get update" do
    get billings_update_url
    value(response).must_be :success?
  end

  it "should get create" do
    get billings_create_url
    value(response).must_be :success?
  end

end
