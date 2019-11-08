# frozen_string_literal: true

# @api private
# @since 0.1.0
module QuantumCore::Container::RegistryBuilder
  class << self
    # @parma container [QuantumCore::Container]
    # @return [QuantumCore::Container::Registry]
    #
    # @api private
    # @since 0.1.0
    def build(container)
      QuantumCore::Container::Registry.new.tap do |registry|
        container.class.__container_definition_commands__.each do |command|
          command.call(registry)
        end

        container.class.__container_instantiation_commands__.each do |command|
          command.call(registry)
        end
      end
    end
  end
end
