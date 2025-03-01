# frozen_string_literal: true

require_relative "rails_schema_cleaner/version"

module RailsSchemaCleaner
  class Error < StandardError; end

  DEFAULT_TABLES = ["ar_internal_metadata", "schema_migrations"].to_set

  def self.orphaned_tables
    establish_db_connection! unless ActiveRecord::Base.connected?

    db_tables = ActiveRecord::Base.connection.tables.to_set
    model_tables = ActiveRecord::Base.descendants.map(&:table_name).compact.to_set
    db_tables - model_tables - DEFAULT_TABLES
  end

  def self.generate_migration
    tables_to_drop = orphaned_tables
    return puts "No orphaned tables found." if tables_to_drop.empty?

    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
    migration_filename = "db/migrate/#{timestamp}_drop_orphaned_tables.rb"

    # Define the migration class with the correct format
    migration_class = "ActiveRecord::Migration[#{Rails::VERSION::MAJOR}.0]"

    migration_content = <<~RUBY
      class DropOrphanedTables < #{migration_class}
        def change
          #{tables_to_drop.map { |t| "drop_table :#{t}" }.join("\n    ")}
        end
      end
    RUBY

    File.write(migration_filename, migration_content)
    puts "Migration created: #{migration_filename}"
  end

  def self.establish_db_connection!
    require File.expand_path(Dir.pwd + "/config/environment", __FILE__)

    db_config = Rails.configuration.database_configuration[Rails.env]
    ActiveRecord::Base.establish_connection(db_config)

    Rails.application.eager_load!

    puts "Database connection established!"
  end
end
