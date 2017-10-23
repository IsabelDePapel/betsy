require "test_helper"

describe ApplicationController do
  describe "get_current_user" do
    it "returns the session User" do
      #TODO add to cart
      start_count = User.count
      auth_user = merchants(:one)

      login(auth_user, :github)

      User.count.must_equal start_count
      session[:user_id].must_equal auth_user.user_id
    end

    it "returns a new User if there is no current user in the session" do
      # start_count = User.count
      # auth_user = merchants(:one)
      #
      # login(auth_user, :github)
      #
      # User.count.must_equal start_count
      # session[:user_id].must_equal auth_user.user_id
    end
  end

end
