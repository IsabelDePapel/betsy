class OrderItemsController < ApplicationController
  before_action :authenticate_user

  def change_status
    @order_item = OrderItem.find_by(id: params[:id])
    # byebug
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

    if @merchant.id != @auth_user.id
      flash[:status] = :failure
      flash[:message] = "You can only make changes to your own products"
      return redirect_to merchant_path(@auth_user)
    end

    change = @order_item.change_status(params[:status])

    case change
    when nil
      flash[:status] = :success
      flash[:message] = "No changes made"
    when true
      flash[:status] = :success
      flash[:message] = "Status successfully changed to #{@order_item.status}"
    when false
      flash[:status] = :failure
      flash[:message] = "Unable to change status"
      flash[:details] = @order_item.errors.messages
    end

    @order_item.reload
    # @order_item.status = params[:status]
    #
    # if @order_item.save
    #   flash[:status] = :success
    #   flash[:message] = "Status successfully changed to #{@order_item.status}"
    #
    #   # update inventory if order was canceled
    #   if @order_item.status == "canceled"
    #     @order_item.update_product_quantity(canceled: true)
    #     flash[:details] = { "Quantity": "Inventory increased by #{@order_item.quantity}" }
    #   end
    #
    # else
    #   flash[:status] = :failure
    #   flash[:message] = "Unable to change status"
    #   flash[:details] = @order_item.errors.messages
    # end

    redirect_to merchant_path(@merchant)
  end

  private

  def order_item_params
    return params.require(:order_item).permit(:status)
  end
end
