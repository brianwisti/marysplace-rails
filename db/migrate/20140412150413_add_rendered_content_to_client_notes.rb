class AddRenderedContentToClientNotes < ActiveRecord::Migration
  def change
    add_column :client_notes, :rendered_content, :text
  end
end
