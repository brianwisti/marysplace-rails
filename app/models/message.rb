class Message < ActiveRecord::Base
  attr_accessible :content, :author_id

  validates :content,
    presence: true
end
