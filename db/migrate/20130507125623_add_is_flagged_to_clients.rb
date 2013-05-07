class AddIsFlaggedToClients < ActiveRecord::Migration
  def change
    add_column :clients, :is_flagged, :boolean, default: false

    Client.all.each do |client|
      if client.is_flagged?
        client.update_attributes(is_flagged: true)
      end
    end
  end
end
