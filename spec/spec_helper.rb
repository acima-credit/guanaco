# frozen_string_literal: true

require 'bundler/setup'
require 'guanaco'
require 'guanaco/spec_helper'
require 'active_support/core_ext/object/to_query'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.mock_with :rspec
  config.raise_errors_for_deprecations!

  config.run_all_when_everything_filtered = true
  config.filter_run :focus if ENV['FOCUS'] == 'true'
  config.filter_run :focus2 if ENV['FOCUS2'] == 'true'

  config.order = 'random'
  config.disable_monkey_patching!
end
