# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Initializer::Type
  # @return [String]
  #
  # @api private
  # @since 0.5.0
  attr_reader :name

  # @name [Symbol, String]
  # @param checker [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize(name, checker)
    unless name.is_a?(String) || name.is_a?(Symbol)
      raise(SmartCore::Initializer::ArgumentError, "Type name should be a symbol or a string")
    end

    unless checker.is_a?(Proc)
      raise(SmartCore::Initializer::ArgumentError, "Checker should be a proc")
    end

    @name = name.to_sym
    @checker = checker
  end

  # @param value [Any]
  # @return [Boolean]
  #
  # @raise [SmartCore::Initializer::TypeError]
  #
  # @api private
  # @since 0.5.0
  def comparable?(value)
    checker.call(value)
  end

  private

  # @return [Proc]
  #
  # @api private
  # @since 0.5.0
  attr_reader :checker
end
