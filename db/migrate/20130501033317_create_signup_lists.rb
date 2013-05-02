class CreateSignupLists < ActiveRecord::Migration
  def change
    create_table :signup_lists do |t|
      t.integer :points_entry_type_id
      t.date :signup_date

      t.timestamps
    end
  end
end
