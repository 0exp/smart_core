# frozen_string_literal: true

# @api private
# @since 0.1.0
module QuantumCore::Container::DependencyResolver
  class << self
    # @param registry [QuantumCore::Container::Registry]
    # @param dependency_path [String, Symbol]
    # @return [Any, QuantumCore::Container]
    #
    # @see QuantumCore::Container::Registry#resolve
    # @see QuantumCore::Container::Entities::Namespace#call
    # @see QuantumCore::Container::Entities::Dependency#call
    #
    # @api private
    # @since 0.1.0
    def resolve(registry, dependency_path)
      registry.resolve(dependency_path).call
    end
  end
end
