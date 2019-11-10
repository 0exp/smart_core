# frozen_string_literal: true

# @api private
# @since 0.7.0
module SmartCore::Container::DependencyResolver
  class << self
    # @param registry [SmartCore::Container::Registry]
    # @param dependency_path [String, Symbol]
    # @return [SmartCore::Container, Any]
    #
    # @see SmartCore::Container::Registry#resolve
    # @see SmartCore::Container::Entities::Namespace#resolve
    # @see SmartCore::Container::Entities::Dependency#resolve
    #
    # @api private
    # @since 0.7.0
    def resolve(registry, dependency_path)
      registry.resolve(dependency_path).resolve
    end
  end
end
