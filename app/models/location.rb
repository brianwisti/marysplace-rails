class Location < ActiveRecord::Base
  attr_accessible :name, :phone_number, :address, :city, :state, :postal_code

  validates :name,
    presence:   true,
    uniqueness: true

  has_many :checkins,
    dependent: :destroy
  has_many :points_entries,
    dependent: :destroy

  def self.default_location_for user
    last_points_entry = user.points_entries.last

    if last_points_entry && last_points_entry.location
      return last_points_entry.location
    end

    last_checkin = user.checkins.last

    if last_checkin && last_checkin.location
      return last_checkin.location
    end

    return Location.first
  end
end
