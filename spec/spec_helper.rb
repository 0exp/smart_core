# frozen_string_literal: true

require 'simplecov'
require 'simplecov-json'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter,
  Coveralls::SimpleCov::Formatter
])

SimpleCov.start { add_filter 'spec' }

require 'bundler/setup'
require 'smart_core'
require 'pry'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
