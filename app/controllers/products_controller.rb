class ProductsController < ApplicationController

  def home
    # stuff goes here
  end

  def index
    if params[:category_id] == nil && params[:merchant_id] == nil # General product page
      @products = Product.all
    elsif params[:category_id] != nil
      # @products = Product.in_category(params[:category_id])
      category = Category.find_by(id: params[:category_id])
      if category != nil
        @products = category.products
      else
        redirect_to products_path
      end
    elsif params[:merchant_id] != nil
      # @products = Product.in_merchant(params[:merchant_id])
      merchant = Merchant.find_by(id: params[:merchant_id])
      if merchant != nil
        @products = merchant.products
      else
        redirect_to products_path
      end
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

  private
  def product_params
    return params.require(:product).permit(:id, :name, :price, :description, :photo_url, :quantity, :merchant_id)
  end

  def change_visibility
    product = Product.find_by(id: params[:id].to_i)
    # if user is not logged in as the merchant who owns product
    if session[:merchant_id] == nil || session[:merchant_id] != product.merchant.id
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
end
