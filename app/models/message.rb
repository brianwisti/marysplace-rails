class Message < ActiveRecord::Base
  attr_accessible :content, :author_id

  validates :content,
    presence: true
  validates :author_id,
    presence: true

  belongs_to :author,
    class_name: "User"

  def self.since(datetime)
    self.where('created_at > ?', datetime.to_datetime).count
  end
end
