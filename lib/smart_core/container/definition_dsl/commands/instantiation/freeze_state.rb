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

    # @return [SmartCore::Container::DefinitionDSL::Commands::Instantiation::FreezeState]
    #
    # @api private
    # @since 0.7.0
    def dup
      self.class.new
    end
  end
end
