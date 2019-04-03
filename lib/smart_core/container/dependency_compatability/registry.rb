# frozen_string_literal: true

module SmartCore::Container::DependencyCompatability
  # @api private
  # @since 0.5.0
  class Registry < Abstract
    class << self
      # @param registry [SmartCore::Container::Registry]
      # @param dependency [SmartCore::Container::Dependency]
      # @return [void]
      #
      # @raise [SmartCore::Container::NamespaceOverlapError]
      #
      # @api private
      # @since 0.5.0
      def prevent_namespace_overlap!(registry, dependency)
        raise(
          SmartCore::Container::NamespaceOverlapError,
          "Trying to overlap already registered :#{dependency.external_name} " \
          "namespace with :#{dependency.external_name} dependency!"
        ) if potential_namespace_overlap?(registry, dependency)
      end

      # @param registry [SmartCore::Container::Registry]
      # @param namespace [SmartCore::Container::Namespace]
      # @return [void]
      #
      # @raise [SmartCore::Container::DependencyOverlapError]
      #
      # @api private
      # @since 0.5.0
      def prevent_dependency_overlap!(registry, namespace)
        raise(
          SmartCore::Container::DependencyOverlapError,
          "Trying to overlap already registered :#{namespace.external_name} " \
          "dependency with :#{namespace.external_name} namespace!"
        ) if potential_dependency_overlap?(registry, namespace)
      end

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
