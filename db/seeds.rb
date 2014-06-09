# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'
require 'highline/import'
require 'pp'

puts "Creating core users..."
site_admin_role = Role.create! name: 'site_admin'
admin_role = Role.create! name: 'admin'
staff_role = Role.create! name: 'staff'
front_desk_role = Role.create! name: 'front_desk'

puts "Creating site admin user..."
print "Enter an email address: "
email = ask("Enter an email address: ")
passwd = ask("Enter a password: ") { |q| q.echo = "x" }
confirm = ask("Confirm: ") { |q| q.echo = "x" }

admin = User.create!(login: 'admin',
                     email: email,
                     password: passwd,
                     password_confirmation: confirm)
admin.roles << site_admin_role

data_dir = "./seed"

if File.exist? data_dir
  clients = {}
  entry_types = {}

  puts "Importing Clients..."
  client_file = "#{data_dir}/clients.csv"

  raise "Missing #{client_file}" unless File.exist? client_file

  count = 0

  CSV.foreach(client_file) do |row|
    current_alias = row[0]
    full_name = row[1]
    other_aliases = row[2]
    first_name = row[3]
    last_name = row[4]
    oriented_on = row[5]
    birthday = row[6]
    address = row[7]
    family_services = row[8]
    phone_number = row[9]
    email_address = row[10]
    emergency_contact = row[11]
    front_desk_report = row[12]
    case_manager = row[13]
    housing_services = row[14]

    client = Client.create!(current_alias: current_alias,
                            full_name:     full_name,
                            other_aliases: other_aliases,
                            oriented_on:   oriented_on,
                            birthday:      birthday,
                            phone_number:  phone_number,
                            added_by:      admin)
    clients[current_alias] = client.id
    count += 1
    print "\rImported #{count} clients"
  end

  puts

  puts "Importing Points Entry Types..."
  entry_types_file = "#{data_dir}/points_entry_types.csv"

  raise "Missing #{entry_types_file}" unless File.exist? entry_types_file

  count = 0
  CSV.foreach(entry_types_file) do |row|
    name = row[0]
    default_points = row[1]
    entry_type = PointsEntryType.create!(name: name,
                                         default_points: default_points)
    entry_types[name] = entry_type.id
    count += 1
    print "\rImported #{count} entry types"
  end
  puts

  puts "Importing Points Entries..."
  points_entries_file = "#{data_dir}/points_entries.csv"

  raise "Missing #{points_entries_file}" unless File.exist? points_entries_file

  count = 0
  CSV.foreach(points_entries_file) do |row|
    performed_on = row[0]
    client_alias = row[1]
    entry_type_name = row[2]
    points = row[3]
    client_id = clients[client_alias]
    entry_type_id = entry_types[entry_type_name]

    begin
      PointsEntry.create!(client_id: client_id,
                          points_entry_type_id: entry_type_id,
                          performed_on: performed_on,
                          points: points,
                          added_by_id: admin.id)
      count += 1
      print "\rImported #{count} points entries"
    rescue => e
      pp row
      raise e
    end
  end
  puts

end

puts  "Done"
