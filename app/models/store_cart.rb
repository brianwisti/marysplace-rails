class StoreCart < ActiveRecord::Base
  attr_accessible :finished_at, :handled_by_id, :shopper_id, :started_at, :total

  belongs_to :shopper,
    class_name: "Client"

  def self.start(shopper, handler)
    StoreCart.create(shopper_id:    shopper.id,
                     handled_by_id: handler.id,
                     started_at:    DateTime.now,
                     total:         0)
  end

  def finish
    self.update_attributes(finished_at: DateTime.now)
  end
end
