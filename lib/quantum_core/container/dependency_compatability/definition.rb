# frozen_string_literal: true

# @api private
# @since 0.1.0
module QuantumCore::Container::DependencyCompatability::Definition
  class << self
    # @since 0.1.0
    include QuantumCore::Container::DependencyCompatability::General

    # @param container_klass [Class<QuantumCore::Container>]
    # @param dependency_name [String, Symbol]
    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def potential_namespace_overlap?(container_klass, dependency_name)
      begin
        anonymous_container = Class.new(container_klass).new
        anonymous_container.register(dependency_name, &(proc {}))
        false
      rescue QuantumCore::Container::DependencyOverNamespaceOverlapError
        true
      end
    end

    # @param container_klass [Class<QuantumCore::Container>]
    # @param namespace_name [String, Symbol]
    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def potential_dependency_overlap?(container_klass, namespace_name)
      begin
        anonymous_container = Class.new(container_klass).new
        anonymous_container.namespace(namespace_name, &(proc {}))
        false
      rescue QuantumCore::Container::NamespaceOverDependencyOverlapError
        true
      end
    end
  end
end
