class AddAddedByIndexToCatalogItems < ActiveRecord::Migration
  def change
    add_index :catalog_items, :added_by_id
  end
end
