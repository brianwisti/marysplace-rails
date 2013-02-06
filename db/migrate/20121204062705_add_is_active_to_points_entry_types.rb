class AddIsActiveToPointsEntryTypes < ActiveRecord::Migration
  def change
    add_column :points_entry_types, :is_active, :boolean, default: true
  end
end
