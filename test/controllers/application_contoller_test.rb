require "test_helper"

describe ApplicationController do
  describe "get_current_user" do
    # it "returns the session User if not an " do
    #   #TODO add to cart
    #   start_count = User.count
    #   auth_user = merchants(:one)
    #
    #   login(auth_user, :github)
    #
    #   User.count.must_equal start_count
    #   session[:user_id].must_equal auth_user.user_id
    # end

    # it "returns a new User if there is no current user in the session" do
    #   login(merchants(:two), :google_oauth2)
    #   logout_path
    #
    #   session[:user_id].must_be_nil
    #   start_count = User.count
    #
    #   get_current_user.must_be_kind_of User
    #   User.count.must_equal start_count + 1

      # start_count = User.count
      # auth_user = merchants(:one)
      #
      # login(auth_user, :github)
      #
      # User.count.must_equal start_count
      # session[:user_id].must_equal auth_user.user_id
    # end
  end

end
