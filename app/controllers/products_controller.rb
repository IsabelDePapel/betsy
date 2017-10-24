class ProductsController < ApplicationController

  def home
  end

  def index
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
    @product = Product.find_by(id: params[:id].to_i)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    if @product.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @product = Product.find_by(id: params[:id].to_i)

    unless @product
      redirect_to root_path
    end
  end

  def update
    @product = Product.find_by(id: params[:id].to_i)
    redirect_to products_path unless @product

    if @product.update_attributes product_params
      redirect_to products_path
    else
      render :edit
    end
  end

  def destroy
    Product.find_by(id: params[:id])
    @product = Product.find_by
    if @product == nil
      redirect_to root_path
    else @product.destroy
    end
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

  private
  def product_params
    return params.require(:product).permit(:id, :name, :price, :description, :photo_url, :quantity, :merchant_id)
  end

  def change_visibility
    product = Product.find_by(id: params[:id].to_i)
    # if user is not logged in as the merchant who owns product
    if session[:user_id] == nil || session[:user_id] != product.merchant.id
      flash[:error] = "You must be logged in as product owner to change product visibility"
    else
      if product.visible == false
        product.visible = true
        flash[:success] = "Product set to visible"
      else
        product.visible = false
        flash[:success] = "Product set to not visible"
      end
    end

    redirect_to merchant_products_path
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
