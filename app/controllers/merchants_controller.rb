class MerchantsController < ApplicationController
  # Thought process - That we should have a merchant page, which the merchant can view (aka Account page), you can also create a new merchant, edit, update, and delete.

  before_action :authenticate_user, only: [:show, :edit, :update]
  before_action :find_merchant, except: :index

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

    # return if !authorize_merchant
    # if merchant_id is same as logged in
    @products = @merchant.products
    # orders
    @paid = @merchant.order_items.where(status: "paid")
    @complete = @merchant.order_items.where(status: "complete")
    @canceled = @merchant.order_items.where(status: "canceled")
  end

  # def edit
  #   unless @merchant
  #     render_404
  #     return
  #   end
  #
  #   return if !authorize_merchant
  #
  # end
  #
  # def update
  #   unless @merchant
  #     render_404
  #     return
  #   end
  #
  #   return if !authorize_merchant
  #
  #   if @merchant.update_attributes merchant_params
  #     redirect_to merchant_path(@merchant)
  #   else
  #     render :edit, status: :bad_request
  #   end
  # end

  # def new
  #   @merchant = Merchant.new
  # end
  #
  # def create
  #   @merchant = Merchant.new merchant_params
  #   if @merchant.save
  #     redirect_to root_path
  #   else
  #     render :new
  #   end
  # end


  #
  # def destroy
  #   Merchant.find_by(id: params[:id])
  #   @merchant = Merchant.find_by
  #   if @merchant == nil
  #     redirect_to root_path
  #   else @merchant.destroy
  #   end
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

      return redirect_to merchants_path

      # return false
    end

    # return true
  end
end
