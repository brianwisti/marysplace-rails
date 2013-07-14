class ChangeMessageFormattedContentToRenderedContent < ActiveRecord::Migration
  def up
    rename_column :messages, :formatted_content, :rendered_content
  end

  def down
    rename_column :messages, :rendered_content, :formatted_content
  end
end
