class CatalogItemsController < ApplicationController
  before_filter :require_user

  # GET /catalog_items
  # GET /catalog_items.json
  def index
    authorize! :show, CatalogItem

    @catalog_items = CatalogItem.all
  end

  # GET /catalog_items/1
  # GET /catalog_items/1.json
  def show
    authorize! :show, CatalogItem

    @catalog_item = CatalogItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @catalog_item }
    end
  end

  # GET /catalog_items/new
  # GET /catalog_items/new.json
  def new
    authorize! :create, CatalogItem

    @catalog_item = CatalogItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @catalog_item }
    end
  end

  # GET /catalog_items/1/edit
  def edit
    authorize! :edit, CatalogItem

    @catalog_item = CatalogItem.find(params[:id])
  end

  # POST /catalog_items
  # POST /catalog_items.json
  def create
    authorize! :create, CatalogItem

    @catalog_item = CatalogItem.new(params[:catalog_item])
    @catalog_item.added_by = current_user

    respond_to do |format|
      if @catalog_item.save
        format.html {
          redirect_to @catalog_item,
            notice: 'Catalog item was successfully created.'
        }
        format.json {
          render json: @catalog_item, status: :created,
            location: @catalog_item
        }
      else
        format.html { render :new }
        format.json {
          render json: @catalog_item.errors,
            status: :unprocessable_entity
        }
      end
    end
  end

  # PUT /catalog_items/1
  # PUT /catalog_items/1.json
  def update
    authorize! :update, CatalogItem
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
    authorize! :destroy, CatalogItem

    @catalog_item = CatalogItem.find(params[:id])
    @catalog_item.destroy

    respond_to do |format|
      format.html { redirect_to catalog_items_url }
      format.json { head :no_content }
    end
  end
end
