class CategoriesController < ApplicationController

  def index
    @categories = Category.order(:name)
  end


  private
  def category_params
    return params.require(:category).permit(:name)
  end

  def find_product
    if params[:product_id]
      @product = Product.find_by(id: params[:product_id])
      return true
    end
  end

end
