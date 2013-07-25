class StoreCart < ActiveRecord::Base
  attr_accessible :finished_at, :handled_by_id, :shopper_id, :started_at, :total

  belongs_to :shopper,
    class_name: "Client"

  belongs_to :handled_by,
    class_name: "User"

  has_many :items,
    class_name: "StoreCartItem"

  def self.start(shopper, handler)
    StoreCart.create do |cart|
      cart.shopper    = shopper
      cart.handled_by = handler
      cart.started_at = DateTime.now
      cart.total      = 0
    end
  end

  def is_open?
    self.finished_at == nil
  end

  def finish
    now = DateTime.now
    self.update_attributes(finished_at: now)
    PointsEntry.create! do |entry|
      entry.points_entry_type = PointsEntryType.where(name: 'Purchase').first
      entry.client            = self.shopper
      entry.points            = self.total
      entry.performed_on      = now.to_date
      entry.added_by          = self.handled_by
    end
  end

  def update_total
    self.update_attributes(total: self.items.sum('cost'))
  end
end
