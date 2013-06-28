class AddCanShopToClientFlags < ActiveRecord::Migration
  def change
    add_column :client_flags, :can_shop, :boolean, default: true
  end
end
