# frozen_string_literal: true

# @api public
# @since 0.3.0
class SmartCore::Operation::Fatal < SmartCore::Operation::Failure
  # @return [SmartCore::Operation::FatalError]
  #
  # @api private
  # @since 0.3.0
  def exception
    SmartCore::Operation::FatalError.new(self)
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.3.0
  def fatal?
    true.tap { yield(self) if block_given? }
  end
end
