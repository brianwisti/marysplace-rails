class Organization < ActiveRecord::Base
  attr_accessible :creator_id, :name
  
  validates :name, 
    presence: true,
    uniqueness: true
end
