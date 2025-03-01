# RailsSchemaCleaner

## Overview
`rails_schema_cleaner` is a Ruby gem that helps keep your Rails database schema clean by identifying and removing orphaned tables (tables that do not have corresponding ActiveRecord models). It generates a migration file to drop these unused tables safely.

## Installation
Add this gem to your `Gemfile`:

```ruby
gem "rails_schema_cleaner"
```

Then run:

```sh
bundle install
```

Alternatively, install it manually:

```sh
gem install rails_schema_cleaner
```

## Usage
### **1. Detect Orphaned Tables**
To list all tables in the database that do not have an associated model, run:

```sh
bundle exec rails_schema_cleaner detect
```

This will return an array of orphaned table names.

### **2. Generate Migration to Drop Orphaned Tables**
To create a Rails migration file that drops these tables, run:

```sh
bundle exec rails_schema_cleaner clean
```

This will generate a timestamped migration file in `db/migrate/`, e.g.:

```sh
db/migrate/20240228123456_drop_orphaned_tables.rb
```

### **3. Run the Migration**
Execute the migration to drop the orphaned tables:

```sh
rails db:migrate
```

## Compatibility
- Works with Rails >=5.0
- Supports SQLite, PostgreSQL, and MySQL

## How It Works
1. Fetches all database tables using `ActiveRecord::Base.connection.tables`
2. Fetches all existing model table names using `ActiveRecord::Base.descendants.map(&:table_name)`
3. Compares both lists and identifies tables that do not have an associated model
4. Generates a Rails migration file to drop those tables

## Running Tests
Run RSpec tests with:

```sh
rspec
```

## License
This project is licensed under the MIT License.

## Contributions
Pull requests are welcome! Please open an issue to discuss any significant changes before submitting a PR.

## Author
Created by [Hassan Murtaza](https://github.com/hmurtaza7).
