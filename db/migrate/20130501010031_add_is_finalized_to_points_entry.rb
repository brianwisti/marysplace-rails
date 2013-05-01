class AddIsFinalizedToPointsEntry < ActiveRecord::Migration
  def change
    add_column :points_entries, :is_finalized, :boolean, default: true
  end
end
