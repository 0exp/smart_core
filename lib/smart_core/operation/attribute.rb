# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Operation::Attribute
  # @return [Symbol]
  #
  # @api private
  # @since 0.2.0
  attr_reader :name

  # @param name [String, Symbol]
  # @param options [Hash]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize(name, **options)
    unless name.is_a?(Symbol) || name.is_a?(String)
      raise(
        SmartCore::Operation::IncorrectAttributeNameError,
        'Attribute name should be a symbol or a string'
      )
    end

    @name = name
  end

  # @return [SmartCore::Operation::Attribute]
  #
  # @api private
  # @since 0.2.0
  def dup
    self.class.new(name)
  end
end
