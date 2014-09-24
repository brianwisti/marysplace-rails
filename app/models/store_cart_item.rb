class StoreCartItem < ActiveRecord::Base
  belongs_to :catalog_item
  belongs_to :store_cart

  after_save :update_cart_total
  after_destroy :update_cart_total

  validates :cost,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than: 0
    }

  private

  def update_cart_total
    self.store_cart.update_total
  end
end
