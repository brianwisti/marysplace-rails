class DropSignups < ActiveRecord::Migration
  def change
    remove_index :signup_entries, column: "client_id"
    remove_index :signup_entries, column: "points_entry_id"
    remove_index :signup_entries, column: "signup_list_id"
    drop_table :signup_entries

    remove_index :signup_lists, column: "points_entry_type_id"
    drop_table :signup_lists
  end
end
