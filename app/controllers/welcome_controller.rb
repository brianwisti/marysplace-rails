class WelcomeController < ApplicationController
  before_filter :require_user

  def index
    @client_flags = ClientFlag.order('created_at').limit(5)
    @checkin_count = Checkin.today.count
  end
end
