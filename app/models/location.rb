class Location < ActiveRecord::Base
  attr_accessible :name, :phone_number, :address, :city, :state, :postal_code

  validates :name,
    presence:   true,
    uniqueness: true
end
