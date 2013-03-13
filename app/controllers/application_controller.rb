class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user, :sections

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_admin_user
      unless current_user and current_user.role?(:admin)
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      logger.debug "ApplicationController::require_no_user"
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        # redirect_to home_index_path
        return false
      end
    end

    rescue_from CanCan::AccessDenied do |exception|
      flash[:error] = "That resource is unavailable to you."
      redirect_to root_url
    end

    def sections
      # There's *got* to be a prettier way to do this.
      arr = []
      admin_section = {
        title: "Admin",
        url: admin_root_path,
        active: params[:controller] == 'admin'
      }
      user_section = {
        title: "Users", 
        url: users_path, 
        active: params[:controller] == 'users'
      }
      client_section = {
        title: "Clients", 
        url: clients_path, 
        active: params[:controller] == 'clients'
      }
      points_entry_type_section = {
        title: "Points Entry Types", 
        url: points_entry_types_path, 
        active: params[:controller] == 'points_entry_types'
      }
      points_entry_section = {
        title: "Points Log", 
        url: points_entries_path, 
        active: params[:controller] == 'points_entries'
      }
      checkin_section = {
        title: "Checkins", 
        url: checkins_path, 
        active: params[:controller] == 'checkins'
      }
      client_flag_section = {
        title: "Client Flags", 
        url: client_flags_path, 
        active: params[:controller] == 'client_flags'
      }

      if current_user.role? :admin
        arr.push admin_section
      end

      if can? :manage, User
        arr.push user_section
      end

      if can? :show, Client
        arr.push client_section
      end

      if can? :show, PointsEntry
        arr.push points_entry_section
      end
      
      if can? :show, Checkin
        arr.push checkin_section
      end

      # TODO: Actually, this will go into a subsection of points_entries
      #       You know, once points_entries are in place.
      if can? :show, PointsEntryType
        arr.push points_entry_type_section
      end

      if can? :show, ClientFlag
        arr.push client_flag_section
      end

      return arr
    end

    def store_location
      #session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end
