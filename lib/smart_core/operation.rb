# frozen_string_literal: true

# @api public
# @since 0.2.0
class SmartCore::Operation
  require_relative 'operation/exceptions'
  require_relative 'operation/attribute'
  require_relative 'operation/attribute_set'
  require_relative 'operation/attribute_dsl'
  require_relative 'operation/calllable'

  # @since 0.2.0
  extend AttributeDSL
  # @since 0.2.0
  extend Callable

  # @api public
  # @since 0.2.0
  def call; end
end
