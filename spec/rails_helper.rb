ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'simplecov'
require 'database_cleaner'
require 'vcr'
require 'webmock/rspec'

SimpleCov.start

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.include FactoryGirl::Syntax::Methods
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
end

RSpec.configure do |config|
  # Add VCR to all tests
  config.around(:each) do |example|
    options = example.metadata
    if options[:vcr]
      name = example.metadata[:full_description].split(/\s+/, 2).join('/').underscore.gsub(/\./,'/').gsub(/[^\w\/]+/, '_').gsub(/\/$/, '')
      VCR.use_cassette(name, &example)
    else
      VCR.turned_off(&example)
    end
  end
end
