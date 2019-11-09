# frozen_string_literal: true

module QuantumCore::Container::DefinitionDSL::Commands::Definition
  # @api private
  # @since 0.1.0
  class Compose < QuantumCore::Container::DefinitionDSL::Commands::Base
    # @param container_klass [Class<QuantumCore::Container>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(container_klass)
      raise(
        QuantumCore::ArgumentError,
        'Container class should be a subtype of Quantum::Container'
      ) unless container_klass < QuantumCore::Container

      @container_klass = container_klass
    end

    # @param registry [QuantumCore::Container::Registry]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def call(registry)
      QuantumCore::Container::RegistryBuilder.build_definitions(container_klass, registry)
    end

    private

    # @return [Class<QuantumCore::Container>]
    #
    # @api private
    # @since 0.1.0
    attr_reader :container_klass
  end
end
