class AddMultipleAndPointsEnteredToPointsEntry < ActiveRecord::Migration
  def change
    add_column :points_entries, :multiple, :int, default: 1
    add_column :points_entries, :points_entered, :int, default: 0
  end
end
