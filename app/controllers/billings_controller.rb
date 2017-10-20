class BillingsController < ApplicationController
  # billing only exists when nested under order
  before_action :verify_order_exists, only: [:new, :create]

  def new
    @billing = Billing.new
    @billing.order_id = params[:order_id]
  end

  def create
    @billing = Billing.new(billing_params)

    if @billing.save
      flash[:status] = :success
      flash[:message] = "Thank you for your order."

      @order.change_status("paid")

      # redirects to order confirmation page
      # in the meantime
      redirect_to root_path
    else
      flash[:status] = :failure
      flash[:message] = "Unable to complete your payment"
      flash[:details] = @billing.errors.messages
      render :new, status: :bad_request
    end
  end

  private

  def billing_params
    return params.require(:billing).permit(:name, :email, :street1, :street2, :city, :state_prov, :zip, :country, :ccnum, :ccmonth, :ccyear, :order_id)
  end

  def verify_order_exists
    @order = Order.find_by(id: params[:order_id])

    unless @order
      flash[:status] = :failure
      flash[:message] = "Order does not exist"
      redirect_to root_path
    end
  end


  # def index
  # end
  #
  # def show
  # end

  # leaving here in case implementing in ideal version
  # def edit
  # end
  #
  # def update
  # end

  # def delete
  # end
end
