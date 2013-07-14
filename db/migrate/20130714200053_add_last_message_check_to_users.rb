class AddLastMessageCheckToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_message_check, :datetime
  end
end
