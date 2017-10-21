class ReviewsController < ApplicationController
  before_action :verify_product_exists, only: [:new, :create]
  before_action :find_review, only: [:edit, :update]
  # reviews only accessed via products

  def show

  end

  def new # this will have a product id
    @review = Review.new
    @review.product_id = params[:product_id]

    # create new user if user doesn't already exist
    user = session[:user_id] ? User.find_by(id: session[:user_id]) : User.create

    # if user id matches merchant's user id, deny access
    # merchant can't review their own products
    if user.id == @product.merchant.user_id
      flash[:status] = :failure
      flash[:message] = "You're not allowed to review your own products"

      redirect_to root_path
      return
    end

    @review.user_id =user.id

  end

  def create
    # WISHLIST - only allow users to review products they've purchased
    @review = Review.new(review_params)

    if @review.save
      flash[:status] = :success
      flash[:message] = "Thank you for reviewing #{@product.name}!"

      redirect_to product_path(@product)
    else
      flash.now[:status] = :failure
      flash.now[:message] = "Unable to post review of #{@product.name}"
      flash.now[:details] = @review.errors.messages
      render :new, status: :bad_request
    end
  end

  # these are not nested
  def edit
    # only allow user to edit if current user_id matches user_id of person who created the review
  end

  def update

  end

  private

  def review_params
    return params.require(:review).permit(:product_id, :user_id, :rating, :text)
  end

  def verify_product_exists
    @product = Product.find_by(id: params[:product_id])

    unless @product
      flash[:status] = :failure
      flash[:message] = "Product does not exist"
      redirect_to root_path
    end
  end

  def find_review
    @review = Review.find_by(id: prarams[:id])
  end

  # def index
  # end
  #

  #
  # def delete
  # end
  #


end
