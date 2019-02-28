# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Operation::Step
  # @return [String, Symbol]
  #
  # @api private
  # @since 0.5.0
  attr_reader :method_name

  # @return [Hash<Symbol,Any>]
  #
  # @api private
  # @since 0.5.0
  attr_reader :options

  # @param method_name [String, Symbol]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize(method_name, **options)
    unless name.is_a?(Symbol) || name.is_a?(String)
      raise(
        SmartCore::Operation::IncorrectStepNameError,
        'Attribute name should be a symbol or a string'
      )
    end

    @method_name = method_name
    @options = options # TODO: support for another operations
  end

  # @return [SmartCore::Operation::Step]
  #
  # @api private
  # @since 0.5.0
  def dup
    self.class.new(method_name, **options)
  end
end
