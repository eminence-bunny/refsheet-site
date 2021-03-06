ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'rack_session_access/capybara'
require 'webdrivers/chromedriver'
require 'selenium/webdriver'
require 'capybara-screenshot/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.full_backtrace = false

  config.include GraphqlHelper

  if Bullet.enable?
    config.before(:each) do
      Bullet.start_request
    end

    config.after(:each) do
      Bullet.perform_out_of_channel_notifications if Bullet.notification?
      Bullet.end_request
    end
  end

  config.verbose_retry = true
  config.display_try_failure_messages = true

  if ENV['CI']
    config.around :each, :js do |ex|
      ex.run_with_retry retry: 3
    end
  end

  config.retry_callback = proc do |ex|
    # run some additional clean up task - can be filtered by example metadata
    if ex.metadata[:js]
      Capybara.reset!
    end
  end

  # Capybara - Javascript Logs
  config.after(:each, js: true) do |spec|
    errors = page.driver.browser.manage.logs.get(:browser)
      .select { |e| e.level == "SEVERE" && e.message.present? }
      .map(&:message)
      .to_a

    if errors.present?
      puts(errors.join("\n"))
    end
  end
end

DatabaseCleaner.strategy = :truncation
