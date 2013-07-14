class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.text :formatted_content
      t.integer :author_id

      t.timestamps
    end
  end
end
