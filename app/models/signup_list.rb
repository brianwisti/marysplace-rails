class SignupList < ActiveRecord::Base
  attr_accessible :points_entry_type_id, :signup_date

  belongs_to :points_entry_type

  validates :points_entry_type_id,
    presence: true
  validates :signup_date,
    presence: true

  delegate :name,
    to:        :points_entry_type,
    prefix:    true,
    allow_nil: true
end
