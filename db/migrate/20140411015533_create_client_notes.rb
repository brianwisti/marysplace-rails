class CreateClientNotes < ActiveRecord::Migration
  def change
    create_table :client_notes do |t|
      t.string :title
      t.text :content
      t.references :client
      t.references :user

      t.timestamps
    end
    add_index :client_notes, :client_id
    add_index :client_notes, :user_id
  end
end
