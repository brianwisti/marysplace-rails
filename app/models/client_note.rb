class ClientNote < ActiveRecord::Base
  belongs_to :client
  belongs_to :user

  validates :content,
    presence: true
  validates :user,
    presence: true
  validates :client,
    presence: true

  markdownize! :content
end
