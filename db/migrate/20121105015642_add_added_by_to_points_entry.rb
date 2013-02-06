class AddAddedByToPointsEntry < ActiveRecord::Migration
  def change
    add_column :points_entries, :added_by_id, :integer
  end
end
