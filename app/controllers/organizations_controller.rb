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
    build_organization
  end

  def create
    build_organization
    save_organization or render :new
  end

  def edit
    load_organization
  end

  def update
    load_organization
    build_organization
    save_organization or render :edit
  end

  def destroy
    load_organization
    destroy_organization
    redirect_to organizations_url
  end

  private

  def organization_params
    organization_params = params[:organization]
    
    if organization_params
      organization_params.permit(:name)
    else
      {}
    end
  end

  def load_organizations
    @organizations ||= Organization.all
  end

  def load_organization
    @organization ||= Organization.find params[:id]
  end

  def build_organization
    @organization ||= Organization.new
    @organization.attributes = organization_params
    @organization.creator ||= current_user
  end

  def save_organization
    if @organization.save
      redirect_to @organization
    end
  end

  def destroy_organization
    @organization.destroy
  end
end
