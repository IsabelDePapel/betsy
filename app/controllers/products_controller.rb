class ProductsController < ApplicationController

  def index
    @products = Product.all
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
end
