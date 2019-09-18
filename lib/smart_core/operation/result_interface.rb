# frozen_string_literal: true

# @api public
# @since 0.5.2
module SmartCore::Operation::ResultInterface
  # @param result_data [Hash<Symbol,Any>]
  # @return [SmartCore::Operation::Success]
  #
  # @api public
  # @since 0.5.2
  def Success(**result_data) # rubocop:disable Naming/MethodName
    SmartCore::Operation::Success.new(**result_data)
  end

  # @param errors [Array<Symbol|Any>]
  # @return [SmartCore::Operation::Failure]
  #
  # @api public
  # @since 0.5.2
  def Failure(*errors) # rubocop:disable Naming/MethodName
    SmartCore::Operation::Failure.new(*errors)
  end

  # @param custom_logic [Block]
  # @return [SmartCore::Operation::Custom]
  #
  # @api public
  # @since 0.6.0
  def Custom(&custom_logic) # rubocop:disable Naming/MethodName
    SmartCore::Operation::Custom.new(&custom_logic)
  end

  # @param errors [Array<Symbol|Any>]
  # @return [SmartCore::Operation::Fatal]
  #
  # @raise [SmartCore::Operation::FatalError]
  #
  # @api public
  # @since 0.5.2
  def Fatal(*errors) # rubocop:disable Naming/MethodName
    raise SmartCore::Operation::Fatal.new(*errors)
  end
end
