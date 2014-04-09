source 'https://rubygems.org'

ruby "2.1.1"

# Load ENV variables from .env
gem 'dotenv-rails', groups: [ :development ]

gem 'rails', '3.2.17'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


gem 'pg'

gem 'authlogic'
gem 'cancan'
gem 'kaminari'
gem 'haml-rails'
gem 'paperclip'
gem 'aws-sdk'
gem 'has_barcode'
gem 'markdownizer'
gem 'newrelic_rpm'
gem 'mandrill-api'
gem 'excon'

group :development do
  gem 'coveralls', require: false
  gem 'highline' # Used during db seed
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :production do
  gem 'rails_12factor'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  #gem 'compass-rails'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'bootstrap-sass', '~> 3.1.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'therubyrhino', platforms: :jruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :development, :test do
  gem 'faker', '1.3.0'  # for db:anonymize and test factories
  gem 'rspec-rails', '~> 2.13'
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
