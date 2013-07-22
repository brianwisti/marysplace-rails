class StoreCart < ActiveRecord::Base
  attr_accessible :finished_at, :handled_by_id, :shopper_id, :started_at, :total
end
