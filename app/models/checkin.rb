class Checkin < ActiveRecord::Base
  attr_accessible :checkin_at, :notes, :client, :user, :client_id, :user_id, :is_valid, :location_id
  belongs_to :client
  belongs_to :user
  belongs_to :location

  validates :client_id,
    presence: true
  validates :user_id,
    presence: true
  validates :checkin_at,
    presence: true
  validates :location_id,
    presence: true
  validate :no_checkin_for_client_on_same_day

  before_create :validate_client

  delegate :current_alias,
    to:     :client,
    prefix: true
  delegate :login,
    to:     :user,
    prefix: true
  delegate :name,
    to:     :location,
    prefix: true

  # A string description of what time this checkin occurred
  def say_time
    self.checkin_at.strftime("%l:%M %P")
  end

  def validate_client
    if self.client.is_blocked?
      self.is_valid = false
      self.notes = "Please notify staff immediately about #{self.client.current_alias}"
    else
      self.is_valid = true
    end
  end

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

    select(%{
      date_trunc('#{span}', checkin_at) as span, 
      count(id) as checkins
      })
      .where(checkin_at: start..finish)
      .group('span')
      .order('span')
  end

  def self.on(day)
    start_time = day.beginning_of_day
    end_time   = day.end_of_day
    Checkin.where('checkin_at > ? and checkin_at < ?', start_time, end_time)
  end

  def self.today
    today = Date.today
    self.on(today)
  end
end
