require 'simplecov'
require 'coveralls'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require 'dotenv'
Dotenv.load '.env'


require 'authlogic/test_case'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def login user, password: 'waffle'
    post user_sessions_url, params: { login: user.login, password: password }
  end
end
