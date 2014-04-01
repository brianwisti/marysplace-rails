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
    self.name = self.anonymized_name
    self.phone_number = self.anonymized_phone_number
    self.address = self.anonymized_address
    self.city = self.anonymized_city
    self.state = self.anonymized_state
    self.postal_code = self.anonymized_postal_code
  end

  def anonymized_name
    descriptive = %w{House Center Place}.sample
    "#{Faker::Name.first_name} #{descriptive}"
  end

  def anonymized_phone_number
    Faker::PhoneNumber.phone_number
  end

  def anonymized_address
    Faker::Address.street_address
  end

  def anonymized_city
    Faker::Address.city
  end

  def anonymized_state
    Faker::Address.state_abbr
  end

  def anonymized_postal_code
    Faker::Address.postcode
  end
end
