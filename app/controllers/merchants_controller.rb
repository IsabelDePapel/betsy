class MerchantsController < ApplicationController
  # Thought process - That we should have a merchant page, which the merchant can view (aka Account page), you can also create a new merchant, edit, update, and delete.

  before_action :authenticate_user, only: [:show, :edit, :update, :change_item_status]
  before_action :find_merchant, except: :index
  # before_action :authorize_merchant, only: [:show]

  # this is the only public route
  def index
    @merchants = Merchant.order('username ASC')
  end

  # this is ONLY FOR THE AUTHORIZED MERCHANT
  def show
    unless @merchant
      render_404
      return
    end

    return if !authorize_merchant
    # if merchant_id is same as logged in
    @products = @merchant.products
    # orders
    @paid = @merchant.order_items.where(status: "paid")
    @complete = @merchant.order_items.where(status: "complete")
    @canceled = @merchant.order_items.where(status: "canceled")

  end

  # def change_item_status
  #   # changes status of an order item
  #   item = OrderItem.find_by(id: params[:order_item_id])
  #
  #   unless item
  #     render_404
  #     return
  #   end
  #
  #   @merchant = Merchant.find_by(id: params[:merchant_id])
  #
  #   # byebug
  #   return if !authorize_merchant
  #
  #   puts "CHANGING STATUS"
  #   # byebug
  #   item.status = params[:status]
  #   if item.save
  #     flash[:status] = :success
  #     flash[:message] = "Status successfully changed to #{item.reload.status}"
  #     puts "STATUS CHANGED"
  #   else
  #     flash[:status] = :failure
  #     flash[:message] = "Unable to change status"
  #     flash[:details] = item.errors.messages
  #   end
  #
  #   redirect_to merchant_path(@merchant)
  #   puts "DONE WITH CHANGE ITEM STATUS"
  # end


  private

  def merchant_params
    return params.require(:merchant).permit(:username, :email, :uid, :provider, :user_id)
  end

  def find_merchant
    @merchant = Merchant.find_by(id: params[:id])
  end

  def authorize_merchant
    if @merchant.user_id != session[:user_id]
      puts "NOT AUTHORIZED"
      flash[:status] = :failure
      flash[:message] = "You're not authorized to do this"

      redirect_to merchants_path

      return false
    end

    puts "AUTHORIZED"
    return true
  end
end
