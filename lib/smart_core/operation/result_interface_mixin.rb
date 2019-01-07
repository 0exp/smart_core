# frozen_string_literal: true

# @api private
# @since 0.2.0
module SmartCore::Operation::ResultInterfaceMixin
  # @return [SmartCore::Operation::Success]
  #
  # @api public
  # @since 0.2.0
  def Success
    SmartCore::Operation::Success.new
  end

  # @return [SmartCore::Operation::Failure]
  #
  # @api public
  # @since 0.2.0
  def Failure
    SmartCore::Operation::Failure.new
  end
end
