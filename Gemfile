source 'https://rubygems.org'

ruby "2.1.2"

# Load ENV variables from .env
gem 'dotenv-rails', groups: [ :development ]

gem 'rails', '4.0.5'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


gem 'rails4_upgrade'

gem 'actionpack-action_caching', '~>1.0.0'
gem 'actionpack-page_caching', '~>1.0.0'
gem 'actionpack-xml_parser', '~>1.0.0'
gem 'actionview-encoded_mail_to', '~>1.0.4'
gem 'activerecord-session_store', '~>0.0.1'
gem 'activeresource', '~>4.0.0.beta1'
gem 'authlogic'
gem 'aws-sdk'
gem 'bootstrap-sass','~> 3.1.1'
gem 'cancan'
gem 'coffee-rails', '~> 4.0.1'
gem 'excon'
gem 'haml-rails'
gem 'has_barcode'
gem 'jquery-rails'
gem 'kaminari'
gem 'mandrill-api'
gem 'markdownizer'
gem 'newrelic_rpm'
gem 'paperclip'
gem 'pg'
gem 'protected_attributes', '~>1.0.1'
gem 'rails-observers', '~>0.1.1'
gem 'rails-perftest', '~>0.0.2'
gem 'rmagick'
gem 'sass', '~> 3.2.13' # Specify to prevent cache errors on heroku
gem 'sass-rails',   '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'

group :development do
  gem 'coveralls', require: false
  gem 'highline' # Used during db seed
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'faker', '1.3.0'  # for db:anonymize and test factories
  gem 'rspec-rails', '2.99.0' # until deprecations fully resolved
  gem 'factory_girl_rails', '~> 4.2.1'
end

group :test do
  gem 'simplecov', require: false
  gem 'selenium-webdriver', '~> 2.0'
  gem 'capybara-webkit'
  gem 'capybara', '~> 2.2.1'
  gem 'database_cleaner', '~> 1.2.0'
  gem 'launchy', '~> 2.2.0'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Presumably security-related stuff. Couldn't get rake tasks to run
# without these installed by Bundler.
gem 'bcrypt'
gem 'scrypt'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
gem 'thin'
