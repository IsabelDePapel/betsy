class CategoriesController < ApplicationController

  def index
    @categories = Category.order(:name)
    #TODO Add product in category count for view
  end

  def create #TODO Move me to products.rb!!
    find_product
    #break apart list
    cat_list = category_params[:category][:name].split(/\W+/)
    #check array for if cat exists

    cat_list.each do |item|
      if Category.existing_cat?(item)
        @product.add_category(item)
      else
        new_cat = Category.new(name: item)
        if new_cat.save
          @product.add_category(new_cat)
        else
          flash[:status] = :failure
          flash[:message] = "#{new_cat.capitalize} could not be added as a category"
        end
      end
    end
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
