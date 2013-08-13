class AddMoreIndexes < ActiveRecord::Migration
  def up
    add_index :clients, :added_by_id
    add_index :clients, :last_edited_by_id
    add_index :clients, :login_id

    add_index :roles_users, :role_id
    add_index :roles_users, :user_id

    add_index :signup_entries, :signup_list_id
    add_index :signup_entries, :client_id
    add_index :signup_entries, :points_entry_id
  end

  def down
  end
end
