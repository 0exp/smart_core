# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Operation::ActionStep
  # @return [String, Symbol]
  #
  # @api private
  # @since 0.5.0
  attr_reader :method_name

  # @param method_name [String, Symbol]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize(method_name)
    unless name.is_a?(Symbol) || name.is_a?(String)
      raise(
        SmartCore::Operation::IncorrectActionStepNameError,
        'Attribute name should be a symbol or a string'
      )
    end

    @method_name = method_name
  end

  # @return [SmartCore::Operation::ActionStep]
  #
  # @api private
  # @since 0.5.0
  def dup
    self.class.new(method_name)
  end
end
