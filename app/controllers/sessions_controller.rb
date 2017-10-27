class SessionsController < ApplicationController

  def login
    # view with two buttons: one to sign in w/GH; other google
  end

  def logout
    session[:user_id] = nil
    session[:order_id] = nil
    reset_session

    flash[:status] = :success
    flash[:message] = "Successfully logged out"
    return redirect_to products_path
  end

  def create
    auth_hash = request.env['omniauth.auth']
    #ap auth_hash

    @merchant = Merchant.find_by(uid: auth_hash['uid'], provider: auth_hash['provider'])

    if @merchant
      # if session user_id already exists, this session is overwriting it TODO: write controller tests when we know how to have a session
      session[:user_id] = @merchant.user_id
      if session[:order_id]
        new_cart = Order.find(session[:order_id])
        new_cart.change_user(@merchant.user_id)
      else
        session[:order_id] = Order.find_last_cart_id(@merchant.user_id)
      end
      flash[:status] = :success
      flash[:message] = "You're logged in!"

    else
      # check if session user id already exists
      user = current_user
      provider = auth_hash['provider']

      case provider
      when "github"
        @merchant = Merchant.new user_id: user.id, uid: auth_hash['uid'], provider: auth_hash['provider'], username: auth_hash['info']['nickname'], email: auth_hash['info']['email']

      when "google_oauth2"
        @merchant = Merchant.new user_id: user.id, uid: auth_hash['uid'], provider: auth_hash['provider'], username: auth_hash['info']['name'], email: auth_hash['info']['email']
      end

      # only reason this wouldn't work is if omni auth didn't give a provider or db was down
      if @merchant.save
        session[:user_id] = user.id
        flash[:status] = :success
        flash[:message] = "Welcome #{@merchant.username}"
      else
        flash[:status] = :failure
        flash[:message] = "Unable to save profile"
        flash[:details] = @merchant.errors.messages
      end
    end

    # set up a landing page for all merchants??
    redirect_to merchant_path(@merchant)
  end
end
