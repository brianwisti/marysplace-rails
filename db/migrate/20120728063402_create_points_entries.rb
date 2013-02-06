class CreatePointsEntries < ActiveRecord::Migration
  def change
    create_table :points_entries do |t|
      t.references :client, null: false
      t.references :points_entry_type, null: false
      t.date :performed_on, null: false
      t.boolean :bailed, default: false
      t.integer :points, null: false

      t.timestamps
    end
    add_index :points_entries, :client_id
    add_index :points_entries, :points_entry_type_id
  end
end
