# frozen_string_literal: true

# @api private
# @since 0.5.0
module SmartCore::Container::DependencyCompatability
  require_relative 'dependency_compatability/abstract_checker'
  require_relative 'dependency_compatability/command_checker'
  require_relative 'dependency_compatability/registry_checker'
end
