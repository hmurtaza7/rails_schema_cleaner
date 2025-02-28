# frozen_string_literal: true

RSpec.describe RailsSchemaCleaner do
  it "has a version number" do
    expect(RailsSchemaCleaner::VERSION).not_to be nil
  end

  it "returns an empty array when there are no orphaned tables" do
    allow(ActiveRecord::Base).to receive_message_chain(:connection, :tables).and_return(["users"])
    allow(ActiveRecord::Base).to receive(:descendants).and_return([double(table_name: "users")])
  
    expect(RailsSchemaCleaner.orphaned_tables).to be_empty
  end  

  it "identifies orphaned tables correctly" do
    allow(ActiveRecord::Base).to receive_message_chain(:connection, :tables).and_return(["users", "ghost_table"])
    allow(ActiveRecord::Base).to receive(:descendants).and_return([double(table_name: "users")])

    expect(RailsSchemaCleaner.orphaned_tables).to eq(["ghost_table"])
  end

  it "creates a migration file when orphaned tables are found" do
    allow(RailsSchemaCleaner).to receive(:orphaned_tables).and_return(["ghost_table"])
  
    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
    migration_filename = "db/migrate/#{timestamp}_drop_orphaned_tables.rb"
  
    expect(File).to receive(:write).with(migration_filename, kind_of(String))
    RailsSchemaCleaner.generate_migration
  end

  it "does not create a migration file if no orphaned tables exist" do
    allow(RailsSchemaCleaner).to receive(:orphaned_tables).and_return([])
  
    expect(File).not_to receive(:write)
    expect { RailsSchemaCleaner.generate_migration }.to output(/No orphaned tables found/).to_stdout
  end

  it "generates migration with the correct ActiveRecord::Migration version" do
    allow(RailsSchemaCleaner).to receive(:orphaned_tables).and_return(["ghost_table"])
    rails_major_version = Rails::VERSION::MAJOR
  
    expected_migration_class = "ActiveRecord::Migration[#{rails_major_version}.0]"
    
    allow(File).to receive(:write) do |filename, content|
      expect(content).to include(expected_migration_class)
      expect(content).to include("drop_table :ghost_table")
    end
  
    RailsSchemaCleaner.generate_migration
  end  
end
