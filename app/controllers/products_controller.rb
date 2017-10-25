class ProductsController < ApplicationController
  before_action :authenticate_user, except: [:home, :index, :show, :add_to_cart, :remove_from_cart, :update_quantity_in_cart]
  before_action :find_product, except: [:new, :create, :index]
  before_action :authorize_merchant, only: [:edit, :update, :destroy, :change_visibility]

  def home
  end

  def index
    # TODO refactor when have categories (routes denested)
    if from_category? || from_merchant?
      if @category
        @products = @category.products.order(:id)
      elsif @merchant
        @products = @merchant.products.order(:id)
      else #erroneous category_id or merchant_id, render 404?
        redirect_to products_path
      end
    else
      @products = Product.all.order(:id)
    end
  end

  def show
    #render_404 unless @product
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    if @product.save
      redirect_to products_path
    else
      render :new, status: :bad_request
    end
  end

  def edit
    # unless @product
    #   render_404
    #   return
    # end

    # return if !authorize_merchant

  end

  def update
    # unless @product
    #   render_404
    #   return
    # end

    # return if !authorize_merchant

    if @product.update_attributes product_params
      flash[:status] = :success
      flash[:message] = "#{@product.name.capitalize} successfully edited!"
      redirect_to products_path
    else
      flash[:status] = :failure
      flash[:message] = "There was a problem editing the product"
      flash[:details] = @product.errors.messages
      render :edit, status: :bad_request
    end
  end

  def destroy
    # unless @product
    #   render_404
    #   return
    # end

    # return if !authorize_merchant

    @product.destroy

    if @product.destroyed?
      flash[:status] = :success
      flash[:message] = "#{@product.name.capitalize} successfully deleted."
    else
      flash[:status] = :failure
      flash[:message] = "Unable to delete #{@product.name}"
      flash[:details] = @product.errors.messages
    end

    redirect_to products_path
  end

  # products/:id/add_to_cart
  def add_to_cart
    if session[:order_id] == nil # no order exists yet
      user = User.find_by(id: session[:user_id])
      if session[:user_id] == nil #no user session exists yet
        user = User.new
        user.save
        session[:user_id] = user.id
      end
      new_order = Order.new()
      new_order.user = user
      new_order.save
      session[:order_id] = new_order.id
    end
    # by this point, order now exists

    # Create an OrderItem for the Product
    product = Product.find_by(id: params[:product_id])
    cart_order = Order.find_by(id: session[:order_id])
    if !cart_order.add_product_to_order(product) #:product_id is NOT valid
      flash[:status] = :failure
      flash[:message] = "Can't add non-existent product to cart."
    else # product exists, :product_id is valid
      flash[:status] = :success
      flash[:message] = "Successfully added product to cart."
    end
    # by this point, order exists
    redirect_to products_path
  end

  def remove_from_cart
    if session[:order_id]
      order_to_delete_from = Order.find_by(id: session[:order_id])
      order_item_to_delete = OrderItem.find_by(id: params[:order_item_id])

      if order_to_delete_from.remove_order_item_from_order(order_item_to_delete)
        flash[:status] = :success
        flash[:message] = "Successfully deleted item from cart."
      else
        flash[:status] = :failure
        flash[:message] = "This order item is not in the current cart."
      end
    else
      flash[:status] = :failure
      flash[:message] = "Unsuccessfully deleted item from empty cart."
    end
    redirect_to cart_path
  end

  def update_quantity_in_cart
    order_item = OrderItem.find(params[:order_item_id].to_i)
    if order_item
      order_item.update_attribute(:quantity, params["quantity"])
      flash[:status] = :success
      flash[:message] = "Successfully updated quantity in cart"
    else
      flash[:status] = :failure
      flash[:message] = "Couldn't update quantity in cart"
    end
    order_item.save
    redirect_to cart_path
  end

  def change_visibility
    # product = Product.find_by(id: params[:id].to_i)
    # if user is not logged in as the merchant who owns product
    # if session[:user_id] == nil || session[:user_id] != product.merchant.id
    #   flash[:error] = "You must be logged in as product owner to change product visibility"
    # else
    # unless @product
    #   render_404
    #   return
    # end

    # return if !authorize_merchant

    @product.visible = @product.visible == true ? false : true
    status = @product.visible ? "visible" : "not visible"

    if @product.save
      flash[:status] = :success
      flash[:message] = "Product set to #{status}"
    else
      flash[:status] = :failure
      flash[:message] = "There was a problem"
      flash[:details] = @product.errors.messages
    end

    redirect_to merchant_products_path(@auth_user.id)
  end

  private

  def product_params
    return params.require(:product).permit(:id, :name, :price, :description, :photo_url, :quantity, :merchant_id, :visible)
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    return render_404 unless @product
  end

  def authorize_merchant
    if @product.merchant.user_id != session[:user_id]
      flash[:status] = :failure
      flash[:message] = "You can only make changes to your own products"
      return redirect_to products_path
      # return false
    end

    # return true
  end

  def from_category?
    if params[:category_id]
      @category = Category.find_by(id: params[:category_id])
      return true
    end
  end

  def from_merchant?
    if params[:merchant_id]
      @merchant = Merchant.find_by(id: params[:merchant_id])
      return true
    end
  end
end
