class Checkin < ActiveRecord::Base
  attr_accessible :checkin_at, :notes, :client, :user, :client_id, :user_id
  belongs_to :client
  belongs_to :user

  validates :client_id,
    presence: true
  validates :user_id,
    presence: true
  validates :checkin_at,
    presence: true
  validate :no_checkin_for_client_on_same_day 

  def no_checkin_for_client_on_same_day
    time = Time.new(checkin_at.year, checkin_at.month, checkin_at.day, 0, 0)


    if new_record? or client_id_changed?
      if Checkin.where('client_id = ? and checkin_at > ?', client, time).count > 0
        errors[:client_id] << 'already checked in'
      end
    end
  end

  def self.per_month_in(year)
    start = DateTime.new(year.to_i, 1, 1, 0, 0)
    finish = start.end_of_year
    self.report_for_span(start, finish, 'month')
  end

  def self.per_day_in(year, month)
    start = DateTime.new(year.to_i, month.to_i, 1, 0, 0)
    finish = start.end_of_month
    self.report_for_span(start, finish, 'day')
  end

  def self.report_for_span(start, finish, span)
    return unless %w{month day}.include? span
    select("date_trunc('#{span}', checkin_at) as span, count(id) as checkins")
      .where(checkin_at: start..finish)
      .group('span')
      .order('span')
  end

  def self.today
    today = Time.current
    time = Time.new(today.year, today.month, today.day, 0, 0)
    Checkin.where('checkin_at > ?', time)
  end
end
