# frozen_string_literal: true

# @api public
# @since 0.1.0
class SmartCore::Validator
  require_relative 'validator/exceptions'
  require_relative 'validator/command_set'
  require_relative 'validator/error_set'
  require_relative 'validator/commands'
  require_relative 'validator/dsl'

  # @since 0.1.0
  extend DSL

  # @return [ErrorSet]
  #
  # @api private
  # @since 0.1.0
  attr_reader :error_set

  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def initialize
    @error_set = ErrorSet.new
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  def valid?

  end
end
