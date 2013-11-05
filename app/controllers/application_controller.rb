class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user, :sections, :message_count

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def message_count
      return 0 unless current_user

      if current_user.last_message_check
        Message.since(current_user.last_message_check)
      else
        Message.since(current_user.created_at)
      end
    end

    def require_user
      unless current_user
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
      current_controller = params[:controller]
      # There's *got* to be a prettier way to do this.
      arr = []
      user_section = {
        title: "Users",
        url: users_path,
        active: 'users' == current_controller
      }
      client_section = {
        title: "Clients",
        url: clients_path,
        active: 'clients' == current_controller
      }
      points_entry_section = {
        title: "Points Log",
        url: points_entries_path,
        active: 'points_entries' == current_controller
      }
      checkin_section = {
        title: "Checkins",
        url: checkins_path,
        active: 'checkins' == current_controller
      }
      client_flag_section = {
        title: "Client Flags",
        url: client_flags_path,
        active: 'client_flags' == current_controller
      }
      store_section = {
        title: "Store",
        url: store_path,
        active: 'store' == current_controller
      }
      location_section = {
        title: "Locations",
        url: locations_path,
        active: 'locations' == current_controller
      }

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

      if can? :show, ClientFlag
        arr.push client_flag_section
      end

      if can? :show, StoreCart
        arr.push store_section
      end

      if can? :show, Location
        arr.push location_section
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
