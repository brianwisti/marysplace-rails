class AddResolutionToClientFlags < ActiveRecord::Migration
  def change
    add_column :client_flags, :resolution, :text
  end
end
