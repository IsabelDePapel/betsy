require "test_helper"

describe SessionsController do

  describe "login" do
    # no edge case - this is just a view
    it "should return success" do
      get login_path
      must_respond_with :success
    end
  end

  describe "create" do  #/auth/:provider/callback
    it "logs in an existing user with github and redirects to root path if successful" do

      start_count = Merchant.count
      auth_user = merchants(:one)

      login(auth_user, :github)

      must_respond_with :redirect
      must_redirect_to products_path
      Merchant.count.must_equal start_count
      session[:user_id].must_equal auth_user.user_id
    end

    it "logs in an existing user with google and redirects to root path if succesful" do
      start_count = Merchant.count
      auth_user = merchants(:two)

      login(auth_user, :google_oauth2)

      must_respond_with :redirect
      must_redirect_to products_path
      Merchant.count.must_equal start_count
      session[:user_id].must_equal auth_user.user_id
    end

    # right now, can only be tested when creates a new user and then new merchant
    # can't test whether session already exists (and user already created)
    it "creates an account for a new user and redirects to products page" do
      skip
      num_merchants = Merchant.count
      num_users = User.count

      user = get_current_user
      new_merch = Merchant.new user_id: user.id, provider: "github", username: "moe", uid: 99, email: "moe@eom.net"

      login(new_merch, :github) # this will save the new user just created

      Merchant.count.must_equal start_count + 1
      User.count.must_equal start_count + 1
      must_respond_with :redirect
      must_redirect_to products_path
      session[:user_id].must_equal user.id
    end
  end

  describe "logout" do
    before do
      login(merchants(:two), :google_oauth2)
    end

    it "should logout the user and reset the session" do
      post logout_path
      session[:user_id].must_be_nil
    end

    it "should clear the cart from session" do
      post logout_path
      session[:order_id].must_be_nil
    end
  end


end
