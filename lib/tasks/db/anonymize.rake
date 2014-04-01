require 'progressbar'

task :ensure_dev do
  unless Rails.env.development?
    puts "Not in development environment!"
    exit 1
  end
end

namespace :db do

  namespace :anonymize do
    desc "Anonymize clients"
    task clients: [ :environment, :ensure_dev ] do
      clients = Client.all
      progress_bar = ProgressBar.new("Clients", clients.count)

      clients.each do |client|
        client.anonymize!
        client.save!
        progress_bar.increment
      end

      puts "Done"
    end

    desc "Anonymize locations"
    task locations: [ :environment, :ensure_dev ] do
      locations = Location.all
      progress_bar = ProgressBar.new("Locations", locations.count)

      locations.each do |location|
        location.anonymize!
        location.save!
        progress_bar.increment
      end

      puts "Done"
    end
  end

  desc "Anonymize significant data"
  task anonymize: %w{
    db:anonymize:clients
    db:anonymize:locations
  }
end
