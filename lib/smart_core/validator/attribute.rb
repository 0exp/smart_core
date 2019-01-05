# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Validator::Attribute
  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  attr_reader :name

  # @param name [String, Symbol]
  # @param default_value [Proc, Object]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(name, default_value = nil)
    unless name.is_a?(Symbol) || name.is_a?(String)
      raise(
        SmartCore::Validator::IncorrectAttributeNameError,
        'Attribute name should be a symbol or a string'
      )
    end

    @name = name.to_sym
    @default_value = default_value
  end

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def default_value
    @default_value.is_a?(Proc) ? @default_value.call : @default_value
  end

  # @return [SmartCore::Validator::Attribute]
  #
  # @api private
  # @since 0.1.0
  def dup
    self.class.new(name, @default_value)
  end
end
