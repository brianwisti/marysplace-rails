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
    authorize! :create, StoreCartItem

    @cart = StoreCart.find(params[:id])
    catalog_item = CatalogItem.find(params[:item_id].to_i)
    cost = params[:item_cost].to_i
    detail = params[:item_detail] || nil

    @cart.items.create! do |item|
      item.catalog_item = catalog_item
      item.cost         = cost
      item.detail       = detail
    end

    flash[:notice] = "Item added to cart"
    redirect_to store_show_path(@cart)
  end

  def remove
    authorize! :destroy, StoreCartItem

    @cart = StoreCart.find(params[:id])
    item = @cart.items.find(params[:item_id])
    item.destroy
    redirect_to store_show_path(@cart)
  end

  def change
  end
end
