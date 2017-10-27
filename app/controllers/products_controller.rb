class ProductsController < ApplicationController
  before_action :authenticate_user, except: [:home, :index, :show, :add_to_cart, :remove_from_cart, :update_quantity_in_cart]
  before_action :find_product, except: [:new, :create, :index]
  # before_action :authorize_merchant, only: [:edit, :update, :destroy, :change_visibility]

  def home
  end

  def index
    if from_category? || from_merchant?
      if @category
        @products = @category.products.where("visible = 'true'").order(:name)
      elsif @merchant
        @products = @merchant.products.where("visible = 'true'").order(:name)
      else
        render_404
        return
      end
    else
      @products = Product.all.where("visible = 'true'").order(:name)
    end
  end

  def show
    # x = 4
    # byebug
    if @product == nil
      render_404
      return
    end

    if @product.merchant.user_id != session[:user_id] && @product.visible == false
      flash[:status] = :failure
      flash[:message] = "This product is unavailable."
      return redirect_to products_path
    end
  end

  def new
    @product = Product.new
  end

  def create
    if params[:product][:visible] == "0"
      params[:product][:visible] = false
    else
      params[:product][:visible] = true
    end

    @product = Product.new product_params
    if @auth_user
      @product.merchant = @auth_user
      if @product.save
        @product.populate_categories(params[:categories_string])

        flash[:status] = :success
        flash[:message] = "#{@product.name.capitalize} successfully saved into database!"
        redirect_to merchant_path(@auth_user)
      else
        flash.now[:status] = :failure
        flash.now[:message] = "#{@product.name.capitalize} unsuccessfully saved into database!"
        flash.now[:details] = @product.errors.messages
        render :new, status: :bad_request
      end
    else
      flash[:status] = :failure
      flash[:message] = "Can't create product without an authorized user logged in."
      redirect_to products_path
    end

  end

  def edit
    unless @product
      render_404
      return
    end


    if !authorize_merchant
      return
    else
      # Prepopulate category textfield with a string of all the categories
      category_str_array = []
      @product.categories.each do |category|
        category_str_array << category.name
      end
      params[:categories_string] = category_str_array.join(", ")
    end

  end

  def update
    unless @product
      render_404
      return
    end

    return if !authorize_merchant

    if @product.update_attributes product_params
      @product.populate_categories(params[:categories_string])
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
    unless @product
      render_404
      return
    end

    return if !authorize_merchant

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
    if !cart_order.add_product_to_order(product, params["quantity"]) #:product_id is NOT valid
      flash[:status] = :failure
      flash[:message] = "Can't add product to cart."
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
    order_item = OrderItem.find_by(id: params[:order_item_id].to_i)
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
    unless @product
      render_404
      return
    end

    return if !authorize_merchant

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
    redirect_to merchant_path(@auth_user.id)
  end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :description, :photo_url, :quantity, :visible)
  end

  def find_product
    @product = Product.find_by(id: params[:id])
  end

  def authorize_merchant
    if @product.merchant.user_id != session[:user_id]
      flash[:status] = :failure
      flash[:message] = "This product is unavailable"
      redirect_to products_path
      return false
    end

    return true
  end

  def from_category?
    if params[:category_id]
      @category = Category.find_by(name: params[:category_id])
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
