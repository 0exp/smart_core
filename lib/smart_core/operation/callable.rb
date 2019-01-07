# frozen_string_literal: true

# @api private
# @since 0.2.0
module SmartCore::Operation::Callable
  # @param arguments [Any]
  # @param options [Hash<Symbil, Any>]
  # @param block [Proc]
  # @return [Any]
  #
  # @api public
  # @since 0.2.0
  def call(*arguments, **options, &block)
    new(*arguments, **options, &block).call
  end
end
