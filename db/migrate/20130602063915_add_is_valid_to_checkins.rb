class AddIsValidToCheckins < ActiveRecord::Migration
  def change
    add_column :checkins, :is_valid, :boolean

    Checkin.all.each do |checkin|
      checkin.update_attributes is_valid: true
    end
  end
end
