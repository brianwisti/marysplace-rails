class AddAddressInfoToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :phone_number, :string
    add_column :locations, :address, :string
    add_column :locations, :city, :string
    add_column :locations, :state, :string
    add_column :locations, :postal_code, :string
  end
end
