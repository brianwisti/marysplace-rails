require 'data-anonymization'

DataAnon::Utils::Logging.logger.level = Logger::INFO

database 'MarysPlace' do
  strategy DataAnon::Strategy::Blacklist
  source_db adapter: 'postgresql',
    host: '127.0.0.1',
    database: 'marysplace_dev'

  table 'clients' do
    primary_key 'id'
    anonymize 'full_name'

    anonymize('full_name') do |field|
      # Names are crazy things. Even crazier than what I allow for here.
      # Fake crazy: 0-2 first names and 1 last name.
      name_length = Random.rand(1..4)
      names = 0.upto(name_length-1).map { 
        DataAnon::Strategy::Field::RandomFirstName.new.anonymize(field) 
      }
      names.push DataAnon::Strategy::Field::RandomLastName.new.anonymize(field)
      names.join ' '
    end
  end
end

