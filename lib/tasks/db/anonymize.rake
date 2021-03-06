require 'progressbar'

# Apply a block to each item in a collection, presenting progress to user on STDOUT
def show_progress(collection, say="Progress", &block)
  progress_bar = ProgressBar.new say, collection.count

  collection.each do |thing|
    block.call thing
    progress_bar.increment
  end

  puts # distinguish progress_bar output from other output
end

# Anonymize an ActiveData record, using the record instance's 'anonymize!' method
def anonymize_collection collection
  say = collection.first.class.to_s.pluralize
  show_progress collection, say do |record|
    begin
      record.class.anonymize! record
    end until record.valid?
    record.save!
  end
end

task :ensure_dev do
  unless Rails.env.development?
    puts "Not in development environment!"
    exit 1
  end
end

namespace :db do

  namespace :anonymize do
    dev_env = [ :environment, :ensure_dev ]

    desc "Anonymize clients"
    task clients: dev_env do
      anonymize_collection Client.all
    end

    desc "Anonymize locations"
    task locations: dev_env do
      anonymize_collection Location.all
    end

    desc "Anonymize users (except id 1)"
    task users: dev_env do
      anonymize_collection User.where('id > 1').all
    end

    desc "Anonymize client flags"
    task client_flags: dev_env do
      anonymize_collection ClientFlag.all
    end

    desc "Anonymize points entry types"
    task points_entry_types: dev_env do
      anonymize_collection PointsEntryType.where("name not in ('Purchase', 'Add-On Points', 'Adjustment', 'Adjustment-Penalty')").all
    end
  end

  desc "Anonymize significant data"
  task anonymize: %w{
    db:anonymize:clients
    db:anonymize:locations
    db:anonymize:users
    db:anonymize:client_flags
    db:anonymize:points_entry_types
  }
end
