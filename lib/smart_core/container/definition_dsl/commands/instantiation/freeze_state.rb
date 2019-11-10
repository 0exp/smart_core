# frozen_string_literal: true

module SmartCore::Container::DefinitionDSL::Commands::Instantiation
  # @api private
  # @since 0.7.0
  class FreezeState < SmartCore::Container::DefinitionDSL::Commands::Base
    # @param registry [SmartCore::Container::Registry]
    # @return [void]
    #
    # @api private
    # @since 0.7.0
    def call(registry)
      registry.freeze!
    end
  end
end
