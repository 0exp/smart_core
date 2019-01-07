# frozen_string_literal: true

# @api private
# @since 0.2.0
module SmartCore::Operation::ResultInterfaceMixin
  private

  # @param result_data [Hash<Symbol,Any>]
  # @return [SmartCore::Operation::Success]
  #
  # @api public
  # @since 0.2.0
  def Success(**result_data)
    SmartCore::Operation::Success.new(**result_data)
  end

  # @param errors [Array<Symbol|Any>]
  # @return [SmartCore::Operation::Failure]
  #
  # @api public
  # @since 0.2.0
  def Failure(*errors)
    SmartCore::Operation::Failure.new(*errors)
  end
end
