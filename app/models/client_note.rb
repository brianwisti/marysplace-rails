class ClientNote < ActiveRecord::Base
  belongs_to :client
  belongs_to :user
  attr_accessible :content, :title

  validates :content,
    presence: true
  validates :user,
    presence: true
  validates :client,
    presence: true
end
