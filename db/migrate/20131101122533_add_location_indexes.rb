class AddLocationIndexes < ActiveRecord::Migration
  def up
    add_index :checkins, :location_id,
      name: 'checkins_location_index'
    add_index :points_entries, :location_id,
      name: 'points_entries_location_index'
  end

  def down
    remove_index :checkins, 'checkins_location_index'
    remove_index :points_entries, 'points_entries_location_index'
  end
end
