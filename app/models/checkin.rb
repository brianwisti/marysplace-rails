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
end
