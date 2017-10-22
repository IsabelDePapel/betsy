class ProductsController < ApplicationController

  def index
    if from_category? || from_merchant?
      if @category
        @products = @category.products
      elsif @merchant
        @products = @merchant.products
      else #erroneous category_id or merchant_id, render 404?
        redirect_to products_path
      end
    else
      @products = Product.all
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
    if product == nil #:product_id is NOT valid
      flash[:status] = :failure
      flash[:message] = "Can't add non-existent product to cart."
    else # product exists, :product_id is valid

      # Check if any other order_item has that product
      in_order = false

      order_to_add_to = Order.find_by(id: session[:order_id])
      order_to_add_to.order_items.each do |item|
        # add to quantity if yes
        if item.product == product
          in_order = true
          existing_order_item = OrderItem.find(item.id)
          existing_order_item.quantity += 1
          existing_order_item.save
        end
      end

      # initialize quantity to 1 if no
      if in_order == false
        order_item = OrderItem.new()
        order_item.quantity = 1
        order_item.product = product
        # Assign it an order
        order_item.order = order_to_add_to
        order_item.save
      end

      flash[:status] = :success
      flash[:message] = "Successfully added product to cart."
    end
    # by this point, order exists
    redirect_to products_path
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
