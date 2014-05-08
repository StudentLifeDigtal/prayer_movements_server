require 'simplecov'
unless ENV['CODECLIMATE_REPO_TOKEN'].nil?
  require 'codeclimate-test-reporter'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
end
SimpleCov.start 'rails'

require 'rubygems'
require 'factory_girl_rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = false

  config.infer_base_class_for_anonymous_controllers = false

  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Requests::JsonHelpers, type: :request
  config.include Requests::OAuthHelpers, type: :request
end
