class OrdersController < ApplicationController
  def index
  end

  def show
    # case for cart
    # case for merchant checking their orders they bought
    # case for merchant checking orders from people who bought from them
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

  def cart
    @order = Order.find_by(id: session[:order_id])
  end

  # is there an order already?
  # 	- is there an user?
  # check if theres a user in session (first click to add to cart)
  # if not logged in, creates a new user
  # then creates an order
  # then creates order_items from that product
end
