class AddIndexes < ActiveRecord::Migration
  def up
    add_index :client_flags, :created_by_id
    add_index :client_flags, :resolved_by_id

    add_index :messages, :author_id

    add_index :points_entries, :added_by_id

    add_index :signup_lists, :points_entry_type_id

    add_index :store_cart_items, :store_cart_id
    add_index :store_cart_items, :catalog_item_id

    add_index :store_carts, :shopper_id
    add_index :store_carts, :handled_by_id
  end

  def down
  end
end
