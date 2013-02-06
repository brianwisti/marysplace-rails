class AddIsActiveToClients < ActiveRecord::Migration
  def up
    add_column :clients, :is_active, :boolean, default: true
    Client.reset_column_information
    say_with_time "Updating Client.is_active" do
      Client.all.each do |client|
        client.update_column :is_active, true
      end
    end
  end

  def down
    remove_column :clients, :is_active
  end
end
