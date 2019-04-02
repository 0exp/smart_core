# frozen_string_literal: true

module SmartCore::Container::DependencyCompatability
  # @api private
  # @since 0.5.0
  class CommandSetChecker < AbstractChecker
    # @return [SmartCore::Container::CommandSet]
    #
    # @api private
    # @since 0.5.0
    alias_method :command_set, :dependency_root

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
