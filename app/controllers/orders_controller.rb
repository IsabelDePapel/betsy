class OrdersController < ApplicationController

  before_action :verify_merchant_exists, only: [:index]

  def confirmation
    # check order id is valid
    @order = Order.find_by(id: params[:id])
  end

  # will only existed as nested through merchant
  # must be merchants/:id/index
  def index
    @orders = Order.find_by(merchant_id: params[:merchant_id])
  end

  def show
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

  private



  def verify_merchant_exists
    @merchant = Merchant.find_by(id: params[:merchant_id])

    unless @merchant
      flash[:status] = :failure
      flash[:message] = "User does not exist"
      redirect_to root_path
    end
  end
end # end of controller class
