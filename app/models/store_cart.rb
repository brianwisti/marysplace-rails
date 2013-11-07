class StoreCart < ActiveRecord::Base
  attr_accessible :finished_at, :handled_by_id, :shopper_id, :started_at, :total

  default_scope { order 'started_at DESC' }

  belongs_to :shopper,
    class_name: "Client"

  belongs_to :handled_by,
    class_name: "User"

  has_many :items,
    class_name: "StoreCartItem"

  validates_uniqueness_of :finished_at, scope: :shopper_id

  delegate :current_alias,
    to:     :shopper,
    prefix: true

  def self.start(shopper, handler)
    if shopper.can_shop?
      if cart = shopper.cart
        return cart
      end

      return StoreCart.create do |cart|
        cart.shopper    = shopper
        cart.handled_by = handler
        cart.started_at = DateTime.now
        cart.total      = 0
      end
    end
  end

  def is_open?
    self.finished_at == nil
  end

  def finish
    if self.is_open?
      now = DateTime.now
      self.update_attributes(finished_at: now)
      self.shopper.update_points!
    end
  end

  def update_total
    self.update_attributes(total: self.items.sum('cost'))
  end
end
