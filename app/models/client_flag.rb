class ClientFlag < ActiveRecord::Base
  attr_accessible :action_required, :consequence, :client_id, :created_by, :created_by_id, 
    :description, :expires_on, :is_blocking, :resolved_by_id, :resolved_on

  belongs_to :client
  belongs_to :created_by,
    class_name: "User"
  belongs_to :resolved_by,
    class_name: "User"

  validates :client,
    presence: true
  validates :created_by,
    presence: true
end
