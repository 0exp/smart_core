# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Operation::Attribute
  # @return [Symbol]
  #
  # @api private
  # @since 0.2.0
  attr_reader :name

  # @return [Hash<Symbol,Any>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :options

  # @param name [String, Symbol]
  # @param options [Hash<Symbol,Any>] Supported options:
  #   - :default (see #default_value) (proc or object)
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
    @options = options
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.2.0
  def has_default_value?
    options.key?(:default)
  end

  # @return [Any]
  #
  # @raise [SmartCore::Operation::ArgumentError]
  #
  # @api private
  # @since 0.2.0
  def default_value
    default_value = options.fetch(:default) do
      raise(SmartCore::Operation::ArgumentError, 'Default value is not provided.')
    end

    default_value.is_a?(Proc) ? default_value.call : default_value
  end

  # @return [SmartCore::Operation::Attribute]
  #
  # @api private
  # @since 0.2.0
  def dup
    self.class.new(name, **options)
  end
end
