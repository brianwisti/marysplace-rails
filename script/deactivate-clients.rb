#!/usr/bin/env ruby

current_db = ActiveRecord::Base.connection.current_database
puts "Working in #{current_db}"

total_clients = Client.count
initial_active_clients = Client.where(is_active: true)

puts "Client count:                #{total_clients}"
puts "Initial active client count: #{initial_active_clients.count}"

marker = 2.years.ago.to_date
puts "Inactivity marker timestamp: #{marker}"
pending_inactive_clients = initial_active_clients.where('last_activity_on < ?', marker)
puts "Pending inactive clients:    #{pending_inactive_clients.count}"
pending_inactive_clients.update_all( is_active: false )
