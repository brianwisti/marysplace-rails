class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.integer :user_id, null: false
      t.string :client_fields

      t.timestamps
    end

    add_index :preferences, :user_id, unique: true
  end
end
