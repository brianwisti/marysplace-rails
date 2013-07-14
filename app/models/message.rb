class Message < ActiveRecord::Base
  attr_accessible :content, :author_id

  validates :content,
    presence: true
  validates :author_id,
    presence: true
end
