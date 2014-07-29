class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.integer :user_id, null: false
      t.string :client_fields, array: true, null: false, default: []

      t.timestamps
    end

    add_index :preferences, :user_id, unique: true
  end
end
