module API
  module V0
    class CatalogItemsController < ApplicationController
      before_filter :require_user

      # GET /api/v0/catalog_items.json
      def index
        @items = CatalogItem.all

        render json: @items
      end
    end
  end
end
