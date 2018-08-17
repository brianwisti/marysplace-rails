class AddLastActivityOnToClients < ActiveRecord::Migration
  def change
    add_column :clients, :last_activity_on, :date
  end
end
