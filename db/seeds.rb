# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Creating core users..."
site_admin_role = Role.create! name: 'site_admin'
admin_role = Role.create! name: 'admin'
staff_role = Role.create! name: 'staff'
front_desk_role = Role.create! name: 'front_desk'

# Note that creation of a new site admin is done via `script/new-system.rb`
