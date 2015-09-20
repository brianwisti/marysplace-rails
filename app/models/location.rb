require 'anonymizable'

class Location < ActiveRecord::Base
  extend Anonymizable

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

    return Location.order(:created_at).first
  end

  anonymizes :name do
    descriptive = %w{House Center Place}.sample
    "#{Faker::Name.first_name} #{descriptive}"
  end

  anonymizes :phone_number do
    Faker::PhoneNumber.phone_number
  end

  anonymizes :address do
    Faker::Address.street_address
  end

  anonymizes :city do
    Faker::Address.city
  end

  anonymizes :state do
    Faker::Address.state_abbr
  end

  anonymizes :postal_code do
    Faker::Address.postcode
  end
end
