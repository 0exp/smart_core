# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Operation::InstanceBuilder
  class << self
    # @param operation_object [SmartCore::Operation]
    # @param operation_klass [Class<SmartCore::Operation>]
    # @param parameters [Array<Any>]
    # @param options [Hash<Symbol,Any>]
    # @param block [Proc]
    # @return [SmartCore::Operation]
    #
    # @api private
    # @since 0.2.0
    def call(operation_object, operation_klass, parameters, options, block)
      new(operation_object, operation_klass, parameters, options, block).call
    end
  end

  # @param operation_object [SmartCore::Operation]
  # @param operation_klass [Class<SmartCore::Operation>]
  # @param parameters [Array<Any>]
  # @param options [Hash<Symbol,Any>]
  # @param block [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize(operation_object, operation_klass, parameters, options, block)
    @operation_object = operation_object
    @operation_klass = operation_klass
    @parameters = parameters
    @options = options
    @block = block
  end

  # @return [SmartCore::Operation]
  #
  # @api private
  # @since 0.2.0
  def call
    operation_object.tap do
      prevent_parameters_incomparability
      initialize_parameters
      initialize_options
      call_original_methods
    end
  end

  private

  # @return [SmartCore::Operation]
  #
  # @api private
  # @since 0.2.0
  attr_reader :operation_object

  # @return [Class<SmartCore::Operation>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :operation_klass

  # @return [Array<Any>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :parameters

  # @return [Hash<Symbol,Any>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :options

  # @return [Proc]
  #
  # @api private
  # @since 0.2.0
  attr_reader :block

  # An array of the required option attribute names (parameters without default values)
  #
  # @return [Array<Symbol>]
  #
  # @api private
  # @since 0.2.0
  def required_options
    operation_klass.__options__.each.reject(&:has_default_value?).map(&:name)
  end

  # @return [void]
  #
  # @raise [SmartCore::Operation::AttributeError]
  # @raise [SmartCore::Operation::ParameterError]
  # @raise [SmartCore::Operation::OptionError]
  #
  # @api private
  # @since 0.2.0
  def prevent_parameters_incomparability
    unless parameters.size == operation_klass.__params__.size
      raise SmartCore::Operation::ParameterError
    end

    unless required_options.all? { |option| options.key?(option) }
      raise SmartCore::Operation::OptionError
    end
  end

  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize_paramteres
    parameter_names = operation_klass.__params__.map(&:name)
    parameter_pairs = parameter_names.zip(parameters)

    parameter_pairs.each_pair do |parameter_name, parameter_value|
      object.instance_variable_set("@#{parameter_name}", parameter_value)
    end
  end

  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize_options
    operation_klass.__options__.each do |option|
      option_name  = option.name
      option_value = options.fetch(option_name) { option.default_value }

      object.instance_variable_set("@#{option_name}", option_value)
    end
  end

  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def call_original_methods
    object.send(:initialize, *parameters, **options, &block)
  end
end
