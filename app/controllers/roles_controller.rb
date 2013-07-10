class RolesController < ApplicationController
  before_filter :require_user

  def show
    @roles = Role.order(:name)
    @role = Role.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
end
