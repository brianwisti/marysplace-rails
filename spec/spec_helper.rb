# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
#require 'coveralls'

#SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
#  SimpleCov::Formatter::HTMLFormatter,
#  Coveralls::SimpleCov::Formatter
#]

SimpleCov.start 'rails'
#Coveralls.wear!

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require 'authlogic/test_case'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  include Authlogic::TestCase
  config.include FactoryGirl::Syntax::Methods

  Capybara.default_wait_time = 5

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include LoginMacros
end

def expect_forbidden(response)
  expect(response).to redirect_to(root_url)
end

def build_attributes(*args)
  FactoryGirl.build(*args).attributes.delete_if do |k, v|
    ["id", "created_at", "updated_at"].member?(k)
  end
end
