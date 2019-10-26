# frozen_string_literal: true

# @api private
# @since 0.1.0
module QuantumCore::Container::RegistryBuilder
  class << self
    # @parma commands [QuantumCore::Container::DefinitionDSL::CommandSet]
    # @return [QuantumCore::Container::Registry]
    #
    # @api private
    # @since 0.1.0
    def build(commands)
      QuantumCore::Container::Registry.new.tap do |registry|
        commands.each { |command| command.call(registry) }
      end
    end
  end
end
