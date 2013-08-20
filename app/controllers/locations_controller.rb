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
        format.html { redirect_to locations_path, notice: "Location created" }
      else
        format.html { render action: "new" }
      end
    end
  end
end
