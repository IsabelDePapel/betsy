class MerchantsController < ApplicationController
  before_action :find_merchant
  
  def index
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

  def merchant_params
    return params.require(:merchant).permit(:username, :email, :uid, :provider, :user_id)
  end

  def find_merchant
    @merchant = Merchant.find_by(id: params[:id])
  end
end
