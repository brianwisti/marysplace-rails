class CatalogItem < ActiveRecord::Base
  validates :cost,
    presence: true,
    numericality: {
      only_integer: true
    }
  validates :name,
    presence: true,
    uniqueness: true

  belongs_to :added_by,
    class_name: "User"
end
