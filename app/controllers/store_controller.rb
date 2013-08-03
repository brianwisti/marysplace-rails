class StoreController < ApplicationController
  before_filter :require_user

  def index
    @carts = StoreCart.all
  end

  def cannot_shop
    @clients = Client.cannot_shop
  end

  def start
    authorize! :create, StoreCart

    @shopper = Client.find(params[:shopper_id].to_i)
    @handled_by = current_user

    if @shopper.is_shopping?
      @cart = @shopper.cart
      flash[:notice] = "#{@shopper.current_alias} already has a cart open"
    elsif @shopper.can_shop?
      @cart = StoreCart.start(@shopper, @handled_by)
      flash[:notice] = "Cart started for #{@shopper.current_alias}"
    else
      client = %Q[<a href="/clients/#{@shopper.id}">#{@shopper.current_alias}</a>]
      flags = %Q[<a href="/clients/#{@shopper.id}/flags">flags</a>]
      flash[:alert] = "#{client} has #{flags} that prevents shopping.".html_safe
    end

    if @cart
      redirect_to store_show_path(@cart)
    else
      redirect_to store_path
    end
  end

  def show
    authorize! :show, StoreCart

    @cart = StoreCart.find(params[:id])
    @default_item = CatalogItem.first
    @shopper = @cart.shopper
    @initial_balance = @shopper.point_balance - @cart.total
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
    # TODO: Replace with some sort of routing.
    authorize! :create, StoreCartItem
    @errors = []

    @cart = StoreCart.find(params[:id])
    @errors.push("Unable to find cart") unless @cart

    item_id = params[:item_id].to_i
    catalog_item = CatalogItem.where(id: item_id).first
    @errors.push("Unable to find catalog item") unless catalog_item

    cost = params[:item_cost].to_i
    @errors.push("Cost must be greater than zero") if cost < 1


    detail = params[:item_detail] || nil

    if @errors.empty?
      @cart.items.create do |item|
        item.catalog_item = catalog_item
        item.cost         = cost
        item.detail       = detail
      end

      if @store_cart_item
        flash[:notice] = "Item added to cart"
      end
    else
      flash[:alert] = @errors.join('<br>').html_safe
    end

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
