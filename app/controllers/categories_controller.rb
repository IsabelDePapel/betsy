class CategoriesController < ApplicationController

  def index
    @categories = Category.order(:name)
    #TODO Add product in category count for view
  end

  def create #option only comes from a specific product detail page
    find_product
    cat_list = category_params(/\W+/) #break apart list
    #check array for if cat exists
    puts cat_list

    cat_list.each do |item|
      if existing_cat?(item)
        @product.categories << Category.find_by(name: item) #method should be in model (Product model)
      else
        new_cat = Category.new(name: item)
        if new_cat.save
          @product.categories << new_cat
        else
          #??
        end
      end
    end
    # @category = Category.new category_params
    # if @category.save
    #   redirect_to root_path
    # else
    #   render :new
    # end
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
