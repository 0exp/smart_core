# frozen_string_literal: true

# @api private
# @since 0.1.0
module QuantumCore::Container::DefinitionDSL::Commands
  require_relative 'commands/base'
  require_relative 'commands/definition/namespace'
  require_relative 'commands/definition/register'
  require_relative 'commands/instantiation/freeze_state'
end
