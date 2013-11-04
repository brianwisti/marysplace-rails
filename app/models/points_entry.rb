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
    :is_finalized, :location_id

  validates :added_by_id,
    presence: true
  validates :client_id,
    presence: true
  validates :points_entry_type_id,
    presence: true
  validates :location_id,
    presence: true
  validates :points,
    presence: true

  default_scope order('performed_on DESC, id DESC')

  delegate :current_alias,
    to:     :client,
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

  before_create do
    self.performed_on ||= Date.today

    if self.bailed == true
      entry_type = self.points_entry_type.name
      message = "Bailed on #{entry_type} - #{self.performed_on}"
      flag = ClientFlag.create!(client_id: self.client.id,
                                created_by_id: self.added_by_id,
                                description: message,
                                can_shop: false,
                                expires_on: Date.today + 2.weeks)
    end
  end

  def self.per_month_in(year)
    start = Date.new(year.to_i, 1, 1)
    finish = start.end_of_year
    self.report_for_span(start, finish, 'month')
  end

  def self.per_day_in(year, month)
    start = Date.new(year.to_i, month.to_i, 1)
    finish = start.end_of_month
    self.report_for_span(start, finish, 'day')
  end

  def self.report_for_span(start, finish, span)
    return unless %w{month day}.include? span

    select(%{
      date_trunc('#{span}', performed_on) as span,
      sum(points) as points,
      count(id) as entries
      })
      .where(performed_on: start..finish)
      .group('span')
      .order('span')
  end

  # What is the extra points penalty for bailing on a chore?
  # TODO: Make this configurable
  def self.bail_penalty
    100
  end

end
