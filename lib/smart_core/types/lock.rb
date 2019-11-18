# frozen_string_literal: true

# @api private
# @since 0.9.0
class SmartCore::Types::Lock
  # @return [void]
  #
  # @api private
  # @since 0.9.0
  def initialize
    @mutex = Mutex.new
  end

  # @return [Any]
  #
  # @api private
  # @sicne 0.9.0
  def thread_safe(&block)
    @mutex.owned? ? yield : @mutex.synchronize(&block)
  end
end
