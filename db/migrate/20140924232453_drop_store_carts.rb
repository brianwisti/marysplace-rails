class DropStoreCarts < ActiveRecord::Migration
  def change
    remove_index :store_cart_items, column: "store_cart_id"
    remove_index :store_cart_items, column: "catalog_item_id"
    drop_table :store_cart_items
    
    remove_index :store_carts, column: "handled_by_id"
    remove_index :store_carts, column: "shopper_id"
    drop_table :store_carts
    
    remove_index :catalog_items, column: "added_by_id"
    drop_table :catalog_items
  end
end
