class BillingsController < ApplicationController
  # billing only exists when nested under order
  before_action :find_order, only: [:new, :create]

  def new
    # if order not found
    unless @order
      flash[:status] = :failure
      flash[:message] = "Order does not exist"
      # TODO add root_path
      redirect_to root_path
      return
    end

    @billing = Billing.new
  end

  def create
    @billing = Billing.new(billing_params)

    if @billing.save
      flash[:status] = :success
      flash[:message] = "Thank you for your order"

      # change status from pending to paid
      # redirects to order confirmation page
    else
      flash[:status] = :failure
      flash[:message] = "Unable to complete your payment"
      flash[:details] = @billing.errors.messages
      render :new, status: :bad_request
    end
  end

  private

  def billing_params
    return params.require(:billing).permit(:name, :email, :street1, :street2, :state_prov, :zip, :country, :ccnum, :ccmonth, :ccyear, :order_id)
  end

  def find_order
    @order = Order.find_by(id: params[:id])
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
