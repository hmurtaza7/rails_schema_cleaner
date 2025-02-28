# frozen_string_literal: true

RSpec.describe RailsSchemaCleaner do
  it "has a version number" do
    expect(RailsSchemaCleaner::VERSION).not_to be nil
  end

  it "identifies orphaned tables correctly" do
    allow(ActiveRecord::Base).to receive_message_chain(:connection, :tables).and_return(["users", "ghost_table"])
    allow(ActiveRecord::Base).to receive(:descendants).and_return([double(table_name: "users")])

    expect(RailsSchemaCleaner.orphaned_tables).to eq(["ghost_table"])
  end
end
