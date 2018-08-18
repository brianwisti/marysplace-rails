class Organization < ActiveRecord::Base
  validates :name,
    presence: true,
    uniqueness: true

  validates :creator_id,
    presence: true

  belongs_to :creator,
    class_name: User

  has_many :users
end
