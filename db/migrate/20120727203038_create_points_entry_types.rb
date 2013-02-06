class CreatePointsEntryTypes < ActiveRecord::Migration
  def change
    create_table :points_entry_types do |t|
      t.string :name, unique: true, null: false
      t.string :description
      t.integer :default_points, default: 0

      t.timestamps
    end
  end
end
