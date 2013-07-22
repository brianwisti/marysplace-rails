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
  end

  def show
    authorize! :show, StoreCart
    @cart = StoreCart.find(params[:id])
  end

  def finish
  end

  def open
  end

  def add
  end

  def remove
  end

  def change
  end
end
