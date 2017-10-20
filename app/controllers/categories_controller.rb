class CategoriesController < ApplicationController
  def index
  end

  def show
    @category = Category.find_by(id: params[:id])
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
end
