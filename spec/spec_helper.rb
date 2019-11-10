# frozen_string_literal: true

require 'simplecov'

SimpleCov.minimum_coverage 85

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
])

SimpleCov.start { add_filter 'spec' }

require 'bundler/setup'
require 'smart_core'
require 'pry'

RSpec.configure do |config|
  config.filter_run_when_matching :focus
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.order = :random
  Kernel.srand config.seed
end
