class StoreCart < ActiveRecord::Base
  attr_accessible :finished_at, :handled_by_id, :shopper_id, :started_at, :total

  belongs_to :shopper,
    class_name: "Client"

  belongs_to :handled_by,
    class_name: "User"

  def self.start(shopper, handler)
    StoreCart.create do |cart|
      cart.shopper    = shopper
      cart.handled_by = handler
      cart.started_at = DateTime.now
      cart.total      = 0
    end
  end

  def finish
    self.update_attributes(finished_at: DateTime.now)
  end
end
