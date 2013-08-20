class LocationsController < ApplicationController
  before_filter :require_user

  # GET /locations
  def index
    @locations = Location.order('name ASC')
  end

  # GET /locations/1
  def show
    @location = Location.find(params[:id])
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  def create
    @location = Location.new params[:location]

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: "Location created" }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /locations/1
  def update
    @location = Location.find(params[:id])

    if @location.update_attributes(params[:location])
      redirect_to @location, notice: "Location was updated"
    else
      render action: "edit"
    end
  end
end
