class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.references :client
      t.references :user
      t.datetime :checkin_at
      t.text :notes

      t.timestamps
    end
    add_index :checkins, :client_id
    add_index :checkins, :user_id
  end
end
