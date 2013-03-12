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


    if Checkin.where('client_id = ? and checkin_at > ?', client, time).count > 0
      errors[:client_id] << 'already checked in'
    end
  end

  def self.today
    today = Time.now - 7.hours
    time = Time.new(today.year, today.month, today.day, 0, 0)
    Checkin.where('checkin_at > ?', time)
  end
end
