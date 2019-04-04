# frozen_string_literal: true

module SmartCore::Container::DependencyCompatability
  # @api private
  # @since 0.5.0
  class Registry < Abstract
    class << self
      # @param registry [SmartCore::Container::Regsitry]
      # @param dependency_name [String]
      # @return [Boolean]
      #
      # @api private
      # @since 0.5.0
      def potential_namespace_overlap?(registry, dependency_name)
        registry.any? do |registered_dependency|
          next unless registered_dependency.is_a?(SmartCore::Container::Namespace)
          # NOTE: registered_dependency is a namespace
          registered_dependency.external_name == dependency_name
        end
      end

      # @param registry [SmartCore::Container::Regsitry]
      # @param namespace_name [String]
      # @return [Boolean]
      #
      # @api private
      # @since 0.5.0
      def potential_dependency_overlap?(registry, namespace_name)
        registry.any? do |registered_dependency|
          next unless registered_dependency.is_a?(SmartCore::Container::Dependency)
          # NOTE: registered_dependency is a dependency/memoized dependency
          registered_dependency.external_name == namespace_name
        end
      end
    end
  end
end
