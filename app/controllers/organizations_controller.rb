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
    @organization.creator = current_user

    if @organization.save
      redirect_to @organization
    else
      render :new
    end
  end

  def edit
    @organization = Organization.find params[:id]
  end

  def update
    @organization = Organization.find params[:id]

    if @organization.update_attributes params[:organization]
      redirect_to @organization, notice: 'Organization updated'
    else
      render :edit
    end
  end

  def destroy
    @organization = Organization.find params[:id]
    @organization.destroy
    redirect_to organizations_url
  end
end
