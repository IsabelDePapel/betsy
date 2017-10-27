class OrdersController < ApplicationController

  before_action :verify_merchant_exists, only: [:index, :show]

  def confirmation
    find_order
    # if @user != @order.user || !@auth_user && Order.find_by(id: params[:id].to_i).user != @auth_user.user
    if @user != @order.user
      flash[:status] = :failure
      flash[:message] = "Order not available"
      return redirect_to products_path
    end
  end

  # will only existed as nested through merchant
  # must be merchants/:id/orders
  # def index
  #   @orders = Order.find_by(merchant_id: params[:merchant_id])
  # end

  # will only existed as nested through merchant
  # must be merchants/:id/index
  def show
    @order = Order.find_by(id: params[:order_id])

    if !@auth_user || @auth_user.id != params[:merchant_id].to_i
      flash[:status] = :failure
      flash[:message] = "Cannot view order if you're not the authorized owner"
      return redirect_to products_path
    end
    # case for cart
    # case for merchant checking their orders they bought
    # case for merchant checking orders from people who bought from them
  end

  def cart
    @order = Order.find_by(id: session[:order_id])
  end

  private

  def verify_merchant_exists
    @merchant = Merchant.find_by(id: params[:merchant_id])

    unless @merchant
      flash[:status] = :failure
      flash[:message] = "User does not exist"
      return redirect_to merchants_path
    end
  end

  def find_order
    @order = Order.find_by(id: params[:id])
    unless @order
      render_404
      return
    end
  end
end # end of controller class
