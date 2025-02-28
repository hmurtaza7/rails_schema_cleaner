# frozen_string_literal: true

require_relative "rails_schema_cleaner/version"

module RailsSchemaCleaner
  class Error < StandardError; end

  def self.orphaned_tables
    db_tables = ActiveRecord::Base.connection.tables
    model_tables = ActiveRecord::Base.descendants.map(&:table_name).compact
    db_tables - model_tables
  end

  def self.generate_migration
    tables_to_drop = orphaned_tables
    return puts "No orphaned tables found." if tables_to_drop.empty?

    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
    migration_filename = "db/migrate/#{timestamp}_drop_orphaned_tables.rb"

    # Get Rails major version
    rails_major_version = Rails::VERSION::MAJOR

    # Define the migration class with the correct format
    migration_class = "ActiveRecord::Migration[#{rails_major_version}.0]"

    migration_content = <<-RUBY
      class DropOrphanedTables < #{migration_class}
        def change
          #{tables_to_drop.map { |t| "drop_table :#{t}" }.join("\n    ")}
        end
      end
    RUBY

    File.write(migration_filename, migration_content)
    puts "Migration created: #{migration_filename}"
  end
end
