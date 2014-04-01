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

  # Fill my identifying fields with fake data
  # 
  # Replaces fields in the client but does not save them. That allows the one 
  # "maybe" production usage: anonymized display of clients.
  def anonymize!
    descriptive = %w{House Center Place}.sample
    self.name = "#{Faker::Name.first_name} #{descriptive}"
    self.phone_number = Faker::PhoneNumber.phone_number
    self.address = Faker::Address.street_address
    self.city = Faker::Address.city
    self.state = Faker::Address.state_abbr
    self.postal_code = Faker::Address.postcode
  end
end
