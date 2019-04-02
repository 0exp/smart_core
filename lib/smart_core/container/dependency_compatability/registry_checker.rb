# frozen_string_literal: true

module SmartCore::Container::DependencyCompatability
  # @api private
  # @since 0.5.0
  class RegistryChecker < AbstractChecker
    # @return [SmartCore::Container::Registry]
    #
    # @api private
    # @since 0.5.0
    alias_method :registry, :dependency_root

    # @param dependency [SmartCore::Container::Dependency]
    # @return [Boolean]
    #
    # @api private
    # @since 0.5.0
    def potential_namespace_overlap?(dependency)
    end

    # @param namespace [SmartCore::Container::Namespace]
    # @return [Boolean]
    #
    # @api private
    # @since 0.5.0
    def potential_dependency_overlap?(namespace)
    end
  end
end
