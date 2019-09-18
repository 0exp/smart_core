# frozen_string_literal: true

# @api public
# @since 0.6.0
class SmartCore::Operation::Custom < SmartCore::Operation::Result
  # @return [Block]
  #
  # @api public
  # @since 0.6.0
  attr_reader :custom_logic

  # @param custom_logic [Block]
  # @return [void]
  #
  # @api public
  # @since 0.6.0
  def initialize(&custom_logic)
    @custom_logic = custom_logic
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.6.0
  def custom?
    true
  end

  # @param attributes [Array<Any>]
  # @param options [Hash<Any,Any>]
  # @return [Any]
  #
  # @api public
  # @since 0.6.0
  def call(*attributes, **options)
    custom_logic.call(*attributes, **options)
  end
end
