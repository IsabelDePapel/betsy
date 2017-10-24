class CategoriesController < ApplicationController
  def index
    @categories = Category.order(:name)
  end

  def show
    @category = Category.find_by(id: params[:id])
  end

  def update
  end

  def create
  end
end
