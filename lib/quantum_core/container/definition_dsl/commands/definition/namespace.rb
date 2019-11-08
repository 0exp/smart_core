# frozen_string_literal: true

module QuantumCore::Container::DefinitionDSL::Commands::Definition
  # @api private
  # @since 0.1.0
  class Namespace < QuantumCore::Container::DefinitionDSL::Commands::Base
    # @return [String]
    #
    # @api private
    # @since 0.1.0
    attr_reader :namespace_name

    # @param namespace_name [String, Symbol]
    # @param dependencies_definition [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(namespace_name, dependencies_definition)
      QuantumCore::Container::KeyGuard.indifferently_accessable_key(namespace_name).tap do |name|
        @namespace_name = name
        @dependencies_definition = dependencies_definition
      end
    end

    # @param registry [QuantumCore::Container::Registry]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def call(registry)
      registry.register_namespace(namespace_name, &dependencies_definition)
    end

    private

    # @return [Proc]
    #
    # @api private
    # @since 0.1.0
    attr_reader :dependencies_definition
  end
end
