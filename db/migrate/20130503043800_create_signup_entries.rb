class CreateSignupEntries < ActiveRecord::Migration
  def change
    create_table :signup_entries do |t|
      t.integer :signup_list_id
      t.integer :client_id
      t.integer :points_entry_id

      t.timestamps
    end
  end
end
