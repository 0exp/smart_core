# frozen_string_literal: true

# @api private
# @since 0.5.0
module SmartCore::Container::DependencyCompatability
  require_relative 'dependency_compatability/abstract_checker'
  require_relative 'dependency_compatability/command_checker'
  require_relative 'dependency_compatability/registry_checker'
  require_relative 'dependency_compatability/checker_builder'

  class << self
    # @param dependency_tree [SmartCore::Container::Registry, SmartCore::Container::CommandSet]
    # @return [
    #   SmartCore::Container::DependencyCompatability::CommandChecker,
    #   SmartCore::Container::DependencyCompatability::RegistryChecker
    # ]
    def build_checker(dependency_tree)
      CheckerBuilder.build(dependency_tree)
    end
  end
end
