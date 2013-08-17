class AddLocationIdToCheckins < ActiveRecord::Migration
  def change
    location = Location.create(name: "default")
    add_column :checkins, :location_id, :integer

    Checkin.update_all(location_id: location.id)
  end
end
