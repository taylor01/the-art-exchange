require 'database_cleaner/active_record'

RSpec.configure do |config|
  # Configure Database Cleaner
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # Use transactions for non-system tests (fast)
  config.before(:each) do |example|
    unless example.metadata[:type] == :system
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
  end

  config.after(:each) do |example|
    unless example.metadata[:type] == :system
      DatabaseCleaner.clean
    end
  end

  # Use truncation for system tests (required for Capybara)
  config.before(:each, type: :system) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after(:each, type: :system) do
    DatabaseCleaner.clean
  end
end
