
ENV["RAILS_ENV"]          ||= 'test'
ENV["ADMIN_NAME"]         ||= "Testy McTesterson"
ENV["ADMIN_EMAIL"]        ||= 'test@example.com'
ENV["ADMIN_ORG_APP_NAME"] ||= "The Test Place"
ENV['APP_HOSTNAME']       ||= "localhost"

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'authlogic/test_case'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  include Authlogic::TestCase

  config.infer_spec_type_from_file_location!

  Capybara.default_max_wait_time = 5

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
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before :all do
    Excon.defaults[:mock] = true
    Excon.stub({}, {
      body:   '{}',
      status: 200
    })
  end

  config.include LoginMacros
end

# response should indicate no access
def expect_forbidden(response)
  expect(response).to redirect_to(root_url)
end

# save the model to database and reload it in one swoop.
#
# Throws an exception if save fails.
def save_and_reload! model
  model.save!
  model.reload
end
