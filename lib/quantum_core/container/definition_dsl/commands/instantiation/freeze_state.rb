# frozen_string_literal: true

module QuantumCore::Container::DefinitionDSL::Commands::Instantiation
  # @api private
  # @since 0.1.0
  class FreezeState < QuantumCore::Container::DefinitionDSL::Commands::Base
    # @param registry [QuantumCore::Container::Registry]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def call(registry)
      registry.freeze!
    end
  end
end
