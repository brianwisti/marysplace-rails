require 'pp'

# Records a gain or loss of incentive points for a client,
# along with information about the change
# (Examples: performed a chore, bailed on a chore, made a purchase)
class PointsEntry < ActiveRecord::Base
  belongs_to :client
  belongs_to :points_entry_type
  belongs_to :added_by,
    class_name: "User"
  belongs_to :location
  attr_accessible :bailed, :performed_on, :points,
    :client_id, :points_entry_type_id, :added_by_id,
    :is_finalized, :location_id, :multiple, :points_entered

  validates :added_by_id,
    presence: true
  validates :client_id,
    presence: true
  validates :points_entry_type_id,
    presence: true
  validates :location_id,
    presence: true
  validates :points_entered,
    presence: true
  validates :multiple,
    numericality: { 
      equal_to: 1,
      message: "does not apply to negative point entries"
    },
    if:  Proc.new { |entry| entry.points_entered && entry.points_entered < 0 }
  validates :multiple,
    numericality: {
      greater_than: 0
    }

  default_scope order('performed_on DESC, id DESC')

  delegate :current_alias,
    to:     :client,
    prefix: true
  delegate :login,
    to:     :added_by,
    prefix: true
  delegate :name,
    to:     :points_entry_type,
    prefix: true
  delegate :name,
    to:     :location,
    prefix: true
  delegate :point_balance,
    to:     :client,
    prefix: true

  # Many PointsEntries were created before 'points_entered' was a thing.
  after_find do
    if self.points_entered.nil? or self.points_entered = 0
      self.points_entered = self.points / self.multiple
    end
  end

  before_validation do
    self.performed_on ||= Date.today
  end
  
  before_save do
    self.points = self.points_entered * self.multiple
  end

  before_create do
    if self.bailed == true
      entry_type = self.points_entry_type_name
      message = "Bailed on #{entry_type} - #{self.performed_on}"
      flag = ClientFlag.create!(client_id: self.client.id,
                                created_by_id: self.added_by_id,
                                description: message,
                                can_shop: false,
                                expires_on: Date.today + 2.weeks)
    end
  end

  # how many PointsEntry objects  were +performed_on+ today?
  def self.daily_count
    PointsEntry.where('performed_on = ?', Date.today).count
  end

  # What is the extra points penalty for bailing on a chore?
  # TODO: Make this configurable
  def self.bail_penalty
    100
  end

end
