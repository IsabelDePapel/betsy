class CategoriesController < ApplicationController
  def index
  end

  def show
    @category = Category.find_by(id: params[:id])
  end

  def update
  end

  def create
  end
end
