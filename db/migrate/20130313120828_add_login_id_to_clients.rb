class AddLoginIdToClients < ActiveRecord::Migration
  def change
    add_column :clients, :login_id, :integer
  end
end
