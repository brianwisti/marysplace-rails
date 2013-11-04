class Location < ActiveRecord::Base
  attr_accessible :name, :phone_number, :address, :city, :state, :postal_code

  validates :name,
    presence:   true,
    uniqueness: true

  def self.default_location_for user
    last_points_entry = user.points_entries.last

    if last_points_entry && last_points_entry.location
      return last_points_entry.location
    end

    return Location.first
  end
end
