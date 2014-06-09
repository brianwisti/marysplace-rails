class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, null: false, unique: true
      t.integer :creator_id, null: false

      t.timestamps
    end
  end
end
