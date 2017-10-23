class MerchantsController < ApplicationController
  # Thought process - That we should have a merchant page, which the merchant can view (aka Account page), you can also create a new merchant, edit, update, and delete.

  before_action :find_merchant

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id].to_i)
  end

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

  # def edit
  #   @merchant = Merchant.find_by(id: params[:id].to_i)
  #   unless @merchant
  #     redirect_to root_path
  #   end
  # end
  #
  # def update
  #   @merchant = Merchant.find_by(id: params[:id].to_i)
  #   redirect_to merchants_path unless @merchant
  #
  #   if @merchant.update_attributes merchant_params
  #     redirect_to root_path
  #   else
  #     render :edit
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

  # def merchant_params
  #   return params.require(:merchant).permit(:username, :email, :uid, :provider, :user_id)
  # end

  def find_merchant
    @merchant = Merchant.find_by(id: params[:id])
  end
end
