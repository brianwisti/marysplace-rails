class StoreController < ApplicationController
  before_filter :require_user

  def index
    @carts = StoreCart.all
  end

  def start
    authorize! :create, StoreCart

    @shopper = Client.find(params[:shopper_id].to_i)
    @handled_by = current_user
    @cart = StoreCart.start(@shopper, @handled_by)
    redirect_to store_show_path(@cart)
  end

  def show
    authorize! :show, StoreCart

    @cart = StoreCart.find(params[:id])
  end

  def finish
    authorize! :update, StoreCart

    @cart = StoreCart.find(params[:id])
    @cart.finish
    redirect_to store_path
  end

  def open
    authorize! :show, StoreCart
  end

  def add
  end

  def remove
  end

  def change
  end
end
