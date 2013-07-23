class CatalogItem < ActiveRecord::Base
  attr_accessible :cost, :description, :is_available, :name, :added_by_id
  validates :cost,
    presence: true
  validates :name,
    presence: true,
    uniqueness: true

  belongs_to :added_by,
    class_name: "User"
end
