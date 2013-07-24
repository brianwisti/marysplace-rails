class CreateStoreCartItems < ActiveRecord::Migration
  def change
    create_table :store_cart_items do |t|
      t.integer :store_cart_id
      t.integer :catalog_item_id
      t.integer :cost
      t.string :detail

      t.timestamps
    end
  end
end
