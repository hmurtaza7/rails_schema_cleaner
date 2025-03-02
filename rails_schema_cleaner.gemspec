# frozen_string_literal: true

require_relative "lib/rails_schema_cleaner/version"

Gem::Specification.new do |spec|
  spec.name = "rails_schema_cleaner"
  spec.version = RailsSchemaCleaner::VERSION
  spec.authors = ["Hassan Murtaza"]
  spec.email = ["...@gmail.com"]

  spec.summary = "Cleans up orphaned tables in your Rails database"
  spec.description = "Finds and drops tables that have no corresponding ActiveRecord model"
  spec.homepage = "https://github.com/hmurtaza7/rails_schema_cleaner"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"
  spec.add_dependency "rails", ">= 5.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/hmurtaza7/rails_schema_cleaner"
  spec.metadata["changelog_uri"] = "https://github.com/hmurtaza7/rails_schema_cleaner/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = ["rails_schema_cleaner"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
