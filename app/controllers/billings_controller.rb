class BillingsController < ApplicationController
  # billing only exists when nested under order
  before_action :verify_order_exists, only: [:new, :create]

  def new
    @billing = Billing.new
    #@billing.order_id = params[:order_id]
  end

  def create
    @billing = Billing.new(billing_params)
    @billing.order_id = params[:order_id]

    if @billing.save
      flash[:status] = :success
      flash[:message] = "Thank you for your order."

      # change status to paid and redirect to confirmation page
      @order.change_status("paid")
      session[:order_id] = nil
      redirect_to confirmation_order_path(@order)
    else
      flash.now[:status] = :failure
      flash.now[:message] = "Unable to complete your payment"
      flash.now[:details] = @billing.errors.messages
      render :new, status: :bad_request
    end
  end

  private

  def billing_params
    return params.require(:billing).permit(:name, :email, :street1, :street2, :city, :state_prov, :zip, :country, :ccnum, :ccmonth, :ccyear, :cvv)
  end

  def order_params
    return params.require(:billing).permit(order_items_attributes: :status)
  end

  def verify_order_exists
    @order = Order.find_by(id: params[:order_id])

    unless @order
      flash[:status] = :failure
      flash[:message] = "Order does not exist"
      redirect_to root_path
    end
  end
  
end
