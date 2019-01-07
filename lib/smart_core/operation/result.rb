# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Operation::Result
  # @return [Array<Any>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :__result_attributes__

  # @return [Hash<Symbol, Any>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :__result_options__

  # @param result_attributes [Array<Any>]
  # @param result_options [Hash<Symbol, Any>]
  # @return [void]
  #
  # @api public
  # @since 0.2.0
  def initialize(*result_attributes, **result_options)
    @__result_attributes__ = result_attributes
    @__result_options__ = result_options
  end
end
