class BillingsController < ApplicationController
  # billing only exists when nested under order
  before_action :verify_order_exists, only: [:new, :create]
  before_action :verify_order_has_order_items, only: [:new, :create]

  def new
    @billing = Billing.new
  end

  def create
    @billing = Billing.new(billing_params)
    @billing.order_id = params[:order_id]

    if @billing.valid?
      flash[:status] = :success
      flash[:message] = "Thank you for your order."

      # change status to paid and redirect to confirmation page
      @order.change_status("paid")
      @order.reload
      # returns hash of item name, inventory as key, val if not in stock
      errors = @order.update_inventory

      if !errors.empty?
        flash[:status] = :failure
        flash[:message] = "Unable to complete order. Please edit or remove item from cart"
        flash[:details] = "#{errors[:name]}: only #{errors[:qty]} left in stock"

        return redirect_to cart_path
      end

      @billing.save
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
      return redirect_to products_path
    end
  end

  def verify_order_has_order_items

    if @order.order_items == nil || @order.order_items.count == 0
      flash[:status] = :failure
      flash[:message] = "There are no items in your cart. Please add products to your cart before checking out."

      return redirect_to products_path
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
