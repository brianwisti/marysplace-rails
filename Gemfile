source 'https://rubygems.org'

ruby "2.0.0"

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'highline' # Used during db seed

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

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'bootstrap-sass', '~> 2.3.1.0'
  #gem 'compass-rails'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'therubyrhino', platforms: :jruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :development, :test do
  gem 'rspec-rails', '~> 2.13'
  gem 'factory_girl_rails', '~> 4.2.1'
end

group :test do
  gem 'simplecov', require: false
  gem 'faker', '~> 1.1.2'
  gem 'capybara', '~> 2.0.2'
  gem 'database_cleaner', '~> 0.9.1'
  gem 'launchy', '~> 2.2.0'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
gem 'thin'
