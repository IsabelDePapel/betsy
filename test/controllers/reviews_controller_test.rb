require "test_helper"

describe ReviewsController do
  let(:invalid_product_id) { Product.last.id + 1 }
  let(:macaroon) { products(:macaroon) }
  let(:invalid_review_id) { Review.last.id + 1 }
  let(:cupcake_review) { reviews(:cupcake_review) }

  # NESTED ROUTES /products/:id/reviews
  describe "new" do
    it "should respond with redirect if product doesn't exist" do
      get new_product_review_path(invalid_product_id)

      must_respond_with :redirect
      must_redirect_to products_path
    end

    # COME BACK TO THIS WHEN HAVE OAUTH AND CAN TEST USER EXISTS
    it "should create a new user if user doesn't exist" do
      # confirm no review of macaroons exist
      Review.find_by(product_id: macaroon.id).must_be_nil
      start_count = User.count

      get new_product_review_path(macaroon)

      User.count.must_equal start_count + 1
    end

    it "should use existing user if user exists" do
      start_count = User.count

      # log in user
      auth_user = merchants(:two) # one is selling macaroons
      login(auth_user, :google_oauth2)

      get new_product_review_path(macaroon)

      User.count.must_equal start_count
      Review.last.user_id.must_equal auth_user.user_id
    end

    it "should respond with redirect if merchant tries to review their own products" do
      start_count = User.count

      auth_user = merchants(:one)
      login(auth_user, :github)

      get new_product_review_path(macaroon)

      User.count.must_equal start_count
      must_respond_with :redirect
      must_redirect_to products_path
    end

    it "should respond with success if given valid data" do
      get new_product_review_path(macaroon)
      must_respond_with :success
    end
  end

  describe "create" do
    let(:review_data) { {
      review: {
        text: "goes here",
        rating: 4,
        user_id: users(:two).id,
        product_id: macaroon.id
      }
      } }

    it "should respond with redirect if product doesn't exist" do
      start_count = Review.count

      post product_reviews_path(invalid_product_id), params: review_data

      must_respond_with :redirect
      must_redirect_to products_path
      Review.count.must_equal start_count
    end

    # is invalid user id different than generic bad data?
    it "should respond with bad request and not add review if given invalid data" do
      invalid_data = {
        review: {
          rating: -2,
          user_id: users(:two).id,
          product_id: macaroon.id
        }
      }

      # confirm review actually invalid
      Review.new(invalid_data[:review]).wont_be :valid?
      start_count = Review.count

      post product_reviews_path(macaroon.id), params: invalid_data

      must_respond_with :bad_request
      Review.count.must_equal start_count
    end

    it "should redirect to product page and add review if given valid data" do
      start_count = Review.count

      post product_reviews_path(macaroon.id), params: review_data

      must_respond_with :redirect
      must_redirect_to product_path(macaroon.id)
      Review.count.must_equal start_count + 1
    end
  end

  # NON NESTED ROUTES /reviews/:id
  describe "edit" do
    it "should respond with not found if review doesn't exist" do
      get edit_review_path(invalid_review_id)
      must_respond_with :not_found
    end

    it "should redirect to prev page if user tries to edit another user's review" do
      skip

    end

    it "should respond with success if given valid review id" do
      get review_path(cupcake_review)
      must_respond_with :success
    end
  end

  describe "update" do
    it "should respond with not found if review doesn't exist" do
      patch review_path(invalid_review_id)
      must_respond_with :not_found
    end

    it "should respond with bad request and leave data unchanged if given invalid data" do
      invalid_rating = 6
      orig_rating = cupcake_review.rating

      patch review_path(cupcake_review), params: { review: { rating: invalid_rating } }

      must_respond_with :bad_request

      # confirm data not changed
      cupcake_review.rating.must_equal orig_rating
    end

    it "should update rating and redirect if data is valid" do
      new_rating = 5

      patch review_path(cupcake_review), params: { review: { rating: new_rating } }

      updated_review = Review.find_by(id: cupcake_review.id)
      updated_review.rating.must_equal new_rating
    end

    it "should update text if data valid" do
      new_text = "nom nom nom"

      patch review_path(cupcake_review), params: { review: { text: new_text } }

      updated_review = Review.find_by(id: cupcake_review.id)
      updated_review.text.must_equal new_text
    end
  end

  describe "show" do
    it "should return success if given a valid review id" do
      get review_path(cupcake_review.id)
      must_respond_with :success
    end

    it "should return not found if given a review that doesn't exist" do
      get review_path(invalid_review_id)
      must_respond_with :not_found
    end
  end
end
