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
    load_location
  end

  # POST /locations
  def create
    authorize! :create, Location
    build_location
    save_location or render :new
  end

  # PUT /locations/1
  def update
    authorize! :update, Location
    load_location
    build_location
    save_location or render :edit
  end

  # DELETE /locations/1
  def destroy
    authorize! :destroy, Location
    load_location
    destroy_location

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
    @location.attributes = location_params
  end

  def save_location
    if @location.save
      redirect_to @location
    end
  end

  def destroy_location
    @location.destroy
  end
end
