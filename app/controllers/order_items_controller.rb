class OrderItemsController < ApplicationController
  before_action :authenticate_user

  def change_status
    # ap @auth_user
    @order_item = OrderItem.find_by(id: params[:id])
    # byebug
    # @merchant = Merchant.find_by(id: @order_item.product.id)
    unless @order_item
      render_404
      return
    end


    @merchant = Merchant.find_by(id: @order_item.product.merchant_id)
    # byebug
    unless @merchant
      render_404
      return
    end

    # ap @merchant
    if @merchant.id != @auth_user.id
      puts "NOT AUTHORIZED"
      flash[:status] = :failure
      flash[:message] = "You can only make changes to your own products"
      return redirect_to merchant_path(@auth_user)
    end

    @order_item.status = params[:status]

    if @order_item.save
      flash[:status] = :success
      flash[:message] = "Status successfully changed to #{@order_item.status}"
    else
      flash[:status] = :failure
      flash[:message] = "Unable to change status"
      flash[:details] = @order_item.errors.messages
    end

    redirect_to merchant_path(@merchant)
  end

  private

  def order_item_params
    return params.require(:order_item).permit(:status)
  end
end