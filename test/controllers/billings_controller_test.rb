require "test_helper"

describe BillingsController do

  it "should get new" do
    get billings_new_url
    value(response).must_be :success?
  end


  it "should get create" do
    get billings_create_url
    value(response).must_be :success?
  end

end
