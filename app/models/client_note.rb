class ClientNote < ActiveRecord::Base
  belongs_to :client
  belongs_to :user
  attr_accessible :content, :title, :user_id, :client_id, :rendered_content

  validates :content,
    presence: true
  validates :user,
    presence: true
  validates :client,
    presence: true

  markdownize! :content
end
