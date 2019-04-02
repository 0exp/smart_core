# frozen_string_literal: true

module SmartCore::Container::DependencyCompatability
  # @api private
  # @since 0.5.0
  class Registry < Abstract
    class << self
      # @param registry [SmartCore::Container::Regsitry]
      # @param dependency [SmartCore::Container::Dependency]
      # @return [Boolean]
      #
      # @api private
      # @since 0.5.0
      def potential_namespace_overlap?(registry, dependency)
        registry.any? do |registered_dependency|
          next unless registered_dependency.is_a?(SmartCore::Container::Namespace)
          # NOTE: registered_dependency is a namespace
          dependency.external_name == registered_dependency.external_name
        end
      end

      # @param registry [SmartCore::Container::Regsitry]
      # @param namespace [SmartCore::Container::Namespace]
      # @return [Boolean]
      #
      # @api private
      # @since 0.5.0
      def potential_dependency_overlap?(registry, namespace)
        registry.any? do |registered_dependency|
          next unless registered_dependency.is_a?(SmartCore::Container::Dependency)
          # NOTE: registered_dependency is a dependency/memoized dependency
          namespace.external_name == registered_dependency.external_name
        end
      end
    end
  end
end
