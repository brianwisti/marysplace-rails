class WelcomeController < ApplicationController
  before_filter :require_user

  def index
    @active_flag_count = ClientFlag.active_count
    @checkin_count = Checkin.today.count
    @entry_count   = PointsEntry.daily_count

    if current_user.email.blank? and !session[:email_alert_shown]
      @email_alert_needed = true
      session[:email_alert_shown] = true
    end
  end
end
