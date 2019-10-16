# frozen_string_literal: true

# @api public
# @since 0.6.0
class SmartCore::Operation::Callback < SmartCore::Operation::Result
  # @return [Block]
  #
  # @api public
  # @since 0.6.0
  attr_reader :callback

  # @param callback [Block]
  # @return [void]
  #
  # @api public
  # @since 0.6.0
  def initialize(&callback)
    @callback = callback
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.6.0
  def callback?
    true
  end

  # @param attributes [Array<Any>]
  # @param options [Hash<Any,Any>]
  # @return [Any]
  #
  # @api public
  # @since 0.6.0
  def call(*attributes, **options)
    callback.call(*attributes, **options)
  end
end
