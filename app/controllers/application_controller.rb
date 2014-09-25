# Provides controller helpers for authorization and access levels
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
      if current_user
        flash[:notice] = "You are already logged in"
        redirect_to root_url
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
      sections = {
        User => {
          title: "Users",
          url: users_path,
          permission: :manage,
          active: 'users' == current_controller
        },
        Client => {
          title: "Clients",
          url: clients_path,
          active: 'clients' == current_controller
        },
        PointsEntry => {
          title: "Points Log",
          url: points_entries_path,
          active: 'points_entries' == current_controller
        },
        Checkin => {
          title: "Checkins",
          url: checkins_path,
          active: 'checkins' == current_controller
        },
        ClientFlag => {
          title: "Client Flags",
          url: client_flags_path,
          active: 'client_flags' == current_controller
        },
        Location => {
          title: "Locations",
          url: locations_path,
          active: 'locations' == current_controller
        },
        ClientNote => {
          title: "Client Notes",
          url: client_notes_path,
          active: 'client_notes' == current_controller
        },
        Organization => {
          title: "Organizations",
          url:   organizations_path,
          active: 'organizations' == current_controller
        }
      }

      sections.each do |model, details|
        permission = details[:permission] || :show
        if can? permission, model
          arr.push details
        end
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
