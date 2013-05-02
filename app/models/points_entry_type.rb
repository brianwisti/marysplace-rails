class PointsEntryType < ActiveRecord::Base
  attr_accessible :default_points, :description, :name, :is_active

  validates :name,
    presence: true,
    uniqueness: true

  has_many :points_entries
  has_many :signup_lists

  def self.quicksearch(query)
    starts_with = "#{query}%"
    ends_with = "%#{query}"
    contains = "%#{query}%"
    where('(name = ? or name ilike ? or name ilike ? or name ilike ?) and is_active = true',
          query, starts_with, ends_with, contains)
      .order(:name)
  end
end
