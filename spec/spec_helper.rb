# frozen_string_literal: true

require "active_record"
require "sqlite3"
require "rails_schema_cleaner"

# Establish a temporary in-memory database
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

# Define test tables dynamically
ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :name
  end
  create_table :ghost_table, force: true do |t|
    t.string :data
  end
end

# Define a mock ActiveRecord model
class User < ActiveRecord::Base; end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
