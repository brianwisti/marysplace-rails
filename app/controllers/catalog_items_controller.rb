class CatalogItemsController < ApplicationController
  before_filter :require_user
  authorize_resource

  # GET /catalog_items
  # GET /catalog_items.json
  def index
    @catalog_items = CatalogItem.all
  end

  # GET /catalog_items/1
  def show
    @catalog_item = CatalogItem.find(params[:id])
  end

  # GET /catalog_items/new
  def new
    @catalog_item = CatalogItem.new
  end

  # GET /catalog_items/1/edit
  def edit
    @catalog_item = CatalogItem.find(params[:id])
  end

  # POST /catalog_items
  # POST /catalog_items.json
  def create
    @catalog_item = CatalogItem.new(params[:catalog_item])
    @catalog_item.added_by = current_user

    if @catalog_item.save
      redirect_to @catalog_item,
        notice: 'Catalog item was successfully created.'
    else
      render :new
    end
  end

  # PUT /catalog_items/1
  # PUT /catalog_items/1.json
  def update
    @catalog_item = CatalogItem.find(params[:id])

    respond_to do |format|
      if @catalog_item.update_attributes(params[:catalog_item])
        format.html {
          redirect_to @catalog_item,
            notice: 'Catalog item was successfully updated.'
        }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json {
          render json: @catalog_item.errors,
            status: :unprocessable_entity
        }
      end
    end
  end

  # DELETE /catalog_items/1
  # DELETE /catalog_items/1.json
  def destroy
    @catalog_item = CatalogItem.find(params[:id])
    @catalog_item.destroy

    respond_to do |format|
      format.html { redirect_to catalog_items_url }
      format.json { head :no_content }
    end
  end
end
