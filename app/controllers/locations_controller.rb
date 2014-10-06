class LocationsController < ApplicationController
  before_filter :require_user

  # GET /locations
  def index
    load_locations
  end

  # GET /locations/1
  def show
    load_location
  end

  # GET /locations/new
  def new
    authorize! :create, Location
    build_location
  end

  # GET /locations/1/edit
  def edit
    authorize! :update, Location

    @location = Location.find(params[:id])
  end

  # POST /locations
  def create
    authorize! :create, Location

    @location = Location.new location_params

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: "Location created" }
      else
        format.html { render :new }
      end
    end
  end

  # PUT /locations/1
  def update
    authorize! :update, Location

    @location = Location.find(params[:id])

    if @location.update_attributes location_params
      redirect_to @location, notice: "Location was updated"
    else
      render :edit
    end
  end

  # DELETE /locations/1
  def destroy
    authorize! :destroy, Location

    @location = Location.find(params[:id])
    @location.destroy

    redirect_to locations_url
  end

  private

  def location_params
    location_params = params[:location]

    if location_params
      location_params.permit(:name,
                             :phone_number,
                             :address,
                             :city,
                             :state,
                             :postal_code)
    else
      {}
    end
  end

  def load_locations
    @locations ||= Location.order 'name ASC'
  end

  def load_location
    @location ||= Location.find(params[:id])
  end

  def build_location
    @location ||= Location.new
  end
end
