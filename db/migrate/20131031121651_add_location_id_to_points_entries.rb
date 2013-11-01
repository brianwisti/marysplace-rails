class AddLocationIdToPointsEntries < ActiveRecord::Migration
  def change
    add_column :points_entries, :location_id, :integer
  end
end
