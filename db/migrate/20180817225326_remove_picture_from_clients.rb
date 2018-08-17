class RemovePictureFromClients < ActiveRecord::Migration
  def change
    remove_column :clients, :picture_file_name
    remove_column :clients, :picture_content_type
    remove_column :clients, :picture_file_size
    remove_column :clients, :picture_updated_at
  end
end
