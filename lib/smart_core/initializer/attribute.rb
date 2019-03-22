# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Initializer::Attribute
  require_relative 'attribute/builder'

  # @return [Hash<Symbol,Symbol>]
  #
  # @api private
  # @since 0.5.0
  PRIVACY_MODES = {
    private:   :private,
    protected: :protected,
    public:    :public,
    default:   :public,
  }.freeze

  # @return [Symbol]
  #
  # @api private
  # @since 0.5.0
  attr_reader :name

  # @return [String, Symbol]
  #
  # @api private
  # @since 0.5.0
  attr_reader :type

  # @return [Symbol]
  #
  # @api private
  # @since 0.5.0
  attr_reader :privacy

  # @return [Hash<Symbol,Any>]
  #
  # @api private
  # @since 0.5.0
  attr_reader :options

  # @param name [String, Symbol]
  # @param type [Symbol] (see SmartCore::Initializer::TypeSet, SmartCore::Initializer::Type)
  # @param privacy [Symbol
  # @param options [HAsh<Symbol,Any>] Supported options:
  #   - :default (see #default_value) (proc or object)
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize(name, type, privacy, **options)
    @name = name
    @type = type
    @privacy = privacy
    @options = options
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.5.0
  def has_default_value?
    options.key?(:default)
  end

  # @param value [Any]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def validate_value_type!(value)
    type_checker = SmartCore::Initializer.get_type(type)

    raise(
      SmartCore::Initializer::ArgumentError,
      "Incorrect type of <#{name}> attribute " \
      "(given: #{value.class}, expected: :#{type_checker.name})"
    ) unless type_checker.comparable?(value)
  end

  # @return [Any]
  #
  # @raise [SmartCore::Initializer::ArgumentError]
  #
  # @api private
  # @since 0.5.0
  def default_value
    default_value = options.fetch(:default) do
      raise(SmartCore::Initializer::ArgumentError, 'Default value is not provided.')
    end

    default_value.is_a?(Proc) ? default_value.call : default_value
  end

  # @return [SmartCore::Intializer::Attribute]
  #
  # @api private
  # @since 0.5.0
  def dup
    self.class.new(name, type, privacy, **options)
  end
end
