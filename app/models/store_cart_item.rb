class StoreCartItem < ActiveRecord::Base
  attr_accessible :catalog_item_id, :cost, :detail, :store_cart_id

  belongs_to :catalog_item
  belongs_to :store_cart

  after_create :update_cart_total
  after_destroy :update_cart_total

  private

  def update_cart_total
    self.store_cart.update_total
  end
end
