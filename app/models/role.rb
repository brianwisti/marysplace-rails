class Role < ActiveRecord::Base
  validates :name,
    presence: true,
    uniqueness: true

  has_and_belongs_to_many :users

  scope :org_roles, -> { where 'name != ?', 'site_admin' }
end
