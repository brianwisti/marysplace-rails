namespace :db do

  namespace :anonymize do

    desc "Anonymize clients"
    task clients: :environment do

      # Shortcut to prevent rewriting the production db
      if Rails.env == 'development'
        print "Client: "
        total_count = Client.all.count
        anonymized_count = 0

        Client.all.each do |client|
          print "."
          client.anonymize!

          if client.save
            anonymized_count += 1
          else 
            p client.errors
          end
        end

        puts "#{anonymized_count} / #{total_count} Clients anonymized."
      else
        p "I will not anonymize the #{Rails.env} environment!"
      end

    end
  end

  desc "Anonymize significant data"
  task anonymize: %w{
    db:anonymize:clients
  }
end
