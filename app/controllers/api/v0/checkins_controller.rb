# JSON API
module API

  # Unstable development version of API.
  module V0

    # API for handling client checkins
    class CheckinsController < ApplicationController
      before_filter :require_user

      # POST /api/v0/checkins/create.json
      def create
        login = User.find_by_login params[:login]

        @checkin = Checkin.create do |checkin|
          checkin.client     = login.client
          checkin.user       = current_user
          checkin.checkin_at = DateTime.now
          checkin.location   = Location.find params[:location_id]
        end

        render json: @checkin.receipt, status: :created
      end

    end
  end
end