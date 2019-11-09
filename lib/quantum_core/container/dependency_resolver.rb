# frozen_string_literal: true

# @api private
# @since 0.1.0
module QuantumCore::Container::DependencyResolver
  class << self
    # @param registry [QuantumCore::Container::Registry]
    # @param dependency_path [String, Symbol]
    # @return [QuantumCore::Container, Any]
    #
    # @see QuantumCore::Container::Registry#resolve
    # @see QuantumCore::Container::Entities::Namespace#resolve
    # @see QuantumCore::Container::Entities::Dependency#resolve
    #
    # @api private
    # @since 0.1.0
    def resolve(registry, dependency_path)
      registry.resolve(dependency_path).resolve
    end
  end
end
