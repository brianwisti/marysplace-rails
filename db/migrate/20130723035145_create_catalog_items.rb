class CreateCatalogItems < ActiveRecord::Migration
  def change
    create_table :catalog_items do |t|
      t.string :name
      t.integer :cost
      t.text :description
      t.boolean :is_available, default: true
      t.integer :added_by_id

      t.timestamps
    end
  end
end
