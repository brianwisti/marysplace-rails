class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :current_alias, null: false
      t.string :full_name
      t.text :other_aliases
      t.date :oriented_on
      t.integer :point_balance, default: 0
      t.date :birthday
      t.string :phone_number
      t.text :notes
      t.integer :added_by_id, null: false
      t.integer :last_edited_by_id

      t.timestamps
    end
  end
end
