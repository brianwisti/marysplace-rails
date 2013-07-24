class StoreCartItem < ActiveRecord::Base
  attr_accessible :catalog_item_id, :cost, :detail, :store_cart_id

  belongs_to :catalog_item
  belongs_to :store_cart
end
