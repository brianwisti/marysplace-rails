class AddCurrentAliasIndexToClients < ActiveRecord::Migration
  def change
    add_index :clients, :current_alias, unique: true
  end
end
