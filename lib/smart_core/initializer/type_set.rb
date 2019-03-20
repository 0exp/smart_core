# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Initializer::TypeSet
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize
    @types = {}
  end

  # @param name [String, Symbol]
  # @return [Boolean]
  #
  # @api private
  # @since 0.5.0
  def has_type?(name)
    types.key?(name)
  end

  # @param name [String, Symbol]
  # @param checker [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def register(name, checker)
    type = SmartCore::Initializer::Type.new(name, checker)
    types[type.name] = type
  end

  # @param name [String, Symbol]
  # @return [SmartCore::Initializer::Type]
  #
  # @api private
  # @since 0.5.0
  def resolve(name)
    types.fetch(name.to_sym)
  rescue KeyError
    raise SmartCore::Initializer::UnregisteredTypeError, "#{name} type is not registered!"
  end

  private

  # @return [Hash<Symbol,SmartCore::Initializer::Type>]
  #
  # @api private
  # @since 0.5.0
  attr_reader :types
end
