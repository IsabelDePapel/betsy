class ProductsController < ApplicationController
  def index
  end

  def show
  end

  def edit
  end

  def delete
  end

  def new
  end

  def update
  end

  def create
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
