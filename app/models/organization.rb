class Organization < ActiveRecord::Base
  attr_accessible :creator_id, :name, :logo, :logo_file_name
  attr_accessor :logo
  
  validates :name, 
    presence: true,
    uniqueness: true
  
  validates :creator_id,
    presence: true
  
  belongs_to "creator",
    class_name: User

  has_many :users

  has_attached_file :logo
  validates_attachment :logo,
    content_type: {
      content_type: %w( image/jpeg image/png image/gif )
    }
end
