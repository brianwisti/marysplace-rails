require 'pp'

class PointsEntry < ActiveRecord::Base
  belongs_to :client
  belongs_to :points_entry_type
  belongs_to :added_by,
    class_name: "User"
  attr_accessible :bailed, :performed_on, :points,
    :client_id, :points_entry_type_id, :added_by_id,
    :is_finalized

  validates :added_by_id,
    presence: true
  validates :client_id,
    presence: true
  validates :points_entry_type_id,
    presence: true
  validates :points,
    presence: true

  def summarize
    "#{self.performed_on} #{self.client.current_alias} #{self.points_entry_type.name} #{self.points}"
  end

  before_create do
    self.performed_on ||= Date.today

    if self.bailed == true
      flag = ClientFlag.create!(client_id: self.client.id,
                                created_by_id: self.added_by_id,
                                description: "Bailed on #{self.points_entry_type.name} - #{self.performed_on}",
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
    select("date_trunc('#{span}', performed_on) as span, sum(points) as points, count(id) as entries")
      .where(performed_on: start..finish)
      .group('span')
      .order('span')
  end

end
