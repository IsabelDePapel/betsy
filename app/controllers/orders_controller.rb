class OrdersController < ApplicationController

  before_action :verify_merchant_exists, only: [:index]

  def confirmation
    # check order id is valid
    @order = Order.find_by(id: params[:id])
    # if we don't find an order we should have a 404 error
  end

  # will only existed as nested through merchant
  # must be merchants/:id/index
  def index
    @orders = Order.find_by(merchant_id: params[:merchant_id])
  end

  def show
    # case for cart
    # case for merchant checking their orders they bought
    # case for merchant checking orders from people who bought from them
  end

  def cart
    @order = Order.find_by(id: session[:order_id])
    if @order
      @order_items = @order.order_items.order(:id)
    end
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
end # end of controller class
