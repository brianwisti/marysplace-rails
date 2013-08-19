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
end
