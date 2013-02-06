class PointsEntry < ActiveRecord::Base
  belongs_to :client
  belongs_to :points_entry_type
  belongs_to :added_by,
    class_name: "User"
  attr_accessible :bailed, :performed_on, :points,
    :client_id, :points_entry_type_id, :added_by_id

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
  end

  def self.sum_by_month(args)
    type = args[:type]
    from = args[:from]
    to   = args[:to]
    h = select('performed_on, sum(points)')
      .where(performed_on: from..to,
             points_entry_type_id: type)
      .group('performed_on')
      .order('performed_on')
      .calculate(:sum, :points)
    return h
  end
end
