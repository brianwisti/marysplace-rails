class OrganizationsController < ApplicationController
  before_filter :require_user
  authorize_resource

  def index
    load_organizations
  end

  def show
    load_organization
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new organization_params
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

    if @organization.update_attributes organization_params
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

  private

  def organization_params
    params.require(:organization).permit(:name)
  end

  def load_organizations
    @organizations = Organization.all
  end

  def load_organization
    @organization = Organization.find params[:id]
  end
end
