class OrganizationsController < ApplicationController
  before_filter :require_user
  authorize_resource

  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.find params[:id]
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new params[:organization]
    redirect_to organizations_url
  end

  def edit
    @organization = Organization.find params[:id]
  end

  def update
    @organization = Organization.find params[:id]
    redirect_to organizations_url
  end

  def destroy
    @organization = Organization.find params[:id]
    redirect_to organizations_url
  end
end
