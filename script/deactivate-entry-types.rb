#!/usr/bin/env ruby

current_db = ActiveRecord::Base.connection.current_database
puts "Working in #{current_db}"

total_entry_types = PointsEntryType.count
initial_active_entry_types = PointsEntryType.where(is_active: true)
deactivated_count = 0

puts "Entry type count:                #{total_entry_types}"
puts "Initial active entry type count: #{initial_active_entry_types.count}"

activity_marker = 6.months.ago.to_date
puts "Inactivity marker timestamp:     #{activity_marker}"

initial_active_entry_types.each do |entry_type|
  name = entry_type.name
  latest_entry = entry_type.points_entries.order('performed_on DESC').first

  if latest_entry
    entry_marker = latest_entry.performed_on
  else
    entry_marker =  entry_type.created_at.to_date
  end

  if entry_marker < activity_marker
    entry_type.is_active = false
    entry_type.save!
    puts "DEACTIVATED #{entry_type.name}"
    deactivated_count += 1
  end
end

puts "Entry types deactivated:         #{deactivated_count}"
