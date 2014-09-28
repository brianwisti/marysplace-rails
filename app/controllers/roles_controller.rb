class RolesController < ApplicationController
  before_filter :require_user

  def show
    load_roles
    load_role
  end

  private

  def load_roles
    @roles ||= Role.order :name
  end

  def load_role
    @role ||= Role.find params[:id]
  end
end
