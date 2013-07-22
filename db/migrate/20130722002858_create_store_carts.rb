class CreateStoreCarts < ActiveRecord::Migration
  def change
    create_table :store_carts do |t|
      t.integer :shopper_id
      t.datetime :started_at
      t.datetime :finished_at
      t.integer :handled_by_id
      t.integer :total

      t.timestamps
    end
  end
end
