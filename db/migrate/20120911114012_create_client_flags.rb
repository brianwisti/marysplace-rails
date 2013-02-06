class CreateClientFlags < ActiveRecord::Migration
  def change
    create_table :client_flags do |t|
      t.references :client
      t.integer :created_by_id
      t.text :description
      t.text :consequence
      t.text :action_required
      t.boolean :is_blocking
      t.date :expires_on
      t.integer :resolved_by_id
      t.date :resolved_on

      t.timestamps
    end
    add_index :client_flags, :client_id
  end
end
