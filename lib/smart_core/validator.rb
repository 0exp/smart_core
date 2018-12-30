# frozen_string_literal: true

# @api public
# @since 0.1.0
class SmartCore::Validator
  require_relative 'validator/dsl'
  require_relative 'validator/commands'
  require_relative 'validator/command_set'

  # @since 0.1.0
  extend DSL
end
