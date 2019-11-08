# frozen_string_literal: true

module QuantumCore::Container::DefinitionDSL::Commands::Definition
  # @api private
  # @since 0.1.0
  class Register < QuantumCore::Container::DefinitionDSL::Commands::Base
    # @return [String]
    #
    # @api private
    # @since 0.1.0
    attr_reader :dependency_name

    # @param dependency_name [String, Symbol]
    # @param dependency_definition [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(dependency_name, dependency_definition)
      QuantumCore::Container::KeyGuard.indifferently_accessable_key(dependency_name).tap do |name|
        @dependency_name = name
        @dependency_definition = dependency_definition
      end
    end

    # @param registry [QuantumCore::Container::Registry]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def call(registry)
      registry.register_dependency(dependency_name, &dependency_definition)
    end

    private

    # @return [Proc]
    #
    # @api private
    # @since 0.1.0
    attr_reader :dependency_definition
  end
end
