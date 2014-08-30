require 'anonymizable'

class PointsEntryType < ActiveRecord::Base
  extend Anonymizable

  attr_accessible :default_points, :description, :name, :is_active

  validates :name,
    presence: true,
    uniqueness: true

  has_many :points_entries
  has_many :signup_lists

  scope :active, ->{ where(:is_active => true) }

  def self.quicksearch(query)
    starts_with = "#{query}%"
    ends_with = "%#{query}"
    contains = "%#{query}%"
    where('(name = ? or name ilike ? or name ilike ? or name ilike ?) and is_active = true',
          query, starts_with, ends_with, contains)
      .order(:name)
  end

  anonymizes(:description) { Faker::Lorem.sentence }
  anonymizes :name do
    timings  = [ "Morning", "Afternoon" ]
    locations = [
      "Kitchen",     "Meeting Room", "Elevator",
      "Dining Room", "Bathroom",     "Grounds",
      "Shower",      "Store",        "Office" ,
      "Garbage",     "Donations",    "Breakfast",
      "Lunch"
    ]
    tasks     = [
      "Setup", "Breakdown", "Sweep",
      "Mop",   "Clean"
    ]

    descriptives = []
    if Random.rand.round == 0 then descriptives.push(timings.sample) end
    if Random.rand.round == 0 then descriptives.push(locations.sample) end
    descriptives.push tasks.sample
    descriptives.join ' '
  end
end
