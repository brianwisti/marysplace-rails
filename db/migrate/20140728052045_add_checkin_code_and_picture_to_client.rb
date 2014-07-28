class AddCheckinCodeAndPictureToClient < ActiveRecord::Migration
  def self.up
    add_column :clients, :checkin_code, :string
    add_attachment :clients, :picture
  end

  def self.down
    remove_attachment :clients, :picture
    remove_column :clients, :checkin_code
  end
end
