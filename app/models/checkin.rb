require 'anonymizable'

class Checkin < ActiveRecord::Base
  extend Anonymizable

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
    return unless checkin_at

    time = Time.new(checkin_at.year, checkin_at.month, checkin_at.day, 0, 0)


    if new_record? or client_id_changed?
      if Checkin.where('client_id = ? and checkin_at > ?', client, time).count > 0
        errors[:client_id] << 'already checked in'
      end
    end
  end

  # A short summary for reporting purposes
  def receipt
    receipt = {
      checkin: {
        id:         self.id,
        checkin_at: self.checkin_at,
        client: {
          current_alias: self.client_current_alias
        }
      }
    }
    return receipt
  end

  # create a Checkin from params with alternatives for empty param fields
  def self.with_alternatives params, alt
    checkin = self.new params
    checkin.user       ||= alt[:user]
    checkin.checkin_at ||= Time.zone.now

    unless checkin.client
      checkin.client = Client.where(current_alias: alt[:current_alias]).first
    end

    return checkin
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
    self.on Time.zone.now
  end

end
