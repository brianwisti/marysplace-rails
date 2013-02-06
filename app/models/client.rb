class Client < ActiveRecord::Base
  attr_accessible :added_by, :added_by_id, :birthday, :current_alias, 
    :full_name, :last_edited_by, :last_edited_by_id, :notes, :oriented_on, :other_aliases, 
    :phone_number, :point_balance, :is_active

  validates :current_alias,
    presence: true,
    uniqueness: true
  validates :added_by_id,
    presence: true

  belongs_to :added_by,
    class_name: "User"
  belongs_to :last_edited_by,
    class_name: "User"

  has_many :points_entries
  has_many :checkins
  has_many :client_flags

  before_save do
    self.point_balance ||= 0
  end

  def update_points!
    self.point_balance = self.points_entries.sum(:points)
    self.save
  end

  def is_flagged?
    return self.client_flags.where(resolved_on: nil).count > 0
  end

  def is_blocked?
    return self.client_flags.where(is_blocking: true, resolved_on: nil).count > 0
  end

  def self.quicksearch(query)
    query = query.strip
    starts_with = "#{query}%"
    ends_with = "%#{query}"
    contains = "%#{query}%"
    where('(current_alias = ? or current_alias ilike ? or current_alias ilike ? or current_alias ilike ? or other_aliases ilike ? or other_aliases ilike ? or other_aliases ilike ?) and is_active = true',
          query, starts_with, ends_with, contains, starts_with, ends_with, contains)
      .order(:current_alias)
  end

end
