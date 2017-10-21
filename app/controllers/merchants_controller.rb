class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id].to_i)
  end

  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.new product_params
    if @merchant.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @merchant = Merchant.find_by(id: params[:id].to_i)
    unless @merchant
      redirect_to root_path
    end
  end

  def update
    @merchant = Merchant.find_by(id: params[:id].to_i)
    redirect_to products_path unless @merchant

    if @merchant.update_attributes merchant_params
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    Merchant.find_by(id: params[:id])
    @merchant = Merchant.find_by
    if @merchant == nil
      redirect_to root_path
    else @merchant.destroy
    end
  end

  private
  def merchant_params
    return params.require(:merchant).permit(:merchant_id)
  end

  # def change_visibility
  #   product = Product.find_by(id: params[:id].to_i)
  #   # if user is not logged in as the merchant who owns product
  #   if session[:merchant_id] == nil || session[:merchant_id] != product.merchant.id
  #     flash[:error] = "You must be logged in as product owner to change product visibility"
  #   else
  #     if product.visible == false
  #       product.visible = true
  #       flash[:success] = "Product set to visible"
  #     else
  #       product.visible = false
  #       flash[:success] = "Product set to not visible"
  #     end
  #   end
  #
  #   redirect_to merchant_products_path
  # end
  #
  # def from_category?
  #   if params[:category_id]
  #     @category = Category.find_by(id: params[:category_id])
  #     return true
  #   end
  # end
  #
  # def from_merchant?
  #   if params[:merchant_id]
  #     @merchant = Merchant.find_by(id: params[:merchant_id])
  #     return true
  #   end
  # end
end
