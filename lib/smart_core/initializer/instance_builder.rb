# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Initializer::InstanceBuilder
  class << self
    # @param processed_object [Any]
    # @param processed_klass [Class]
    # @param parameters [Array<Any>]
    # @param options [Hash<Symbol,Any>]
    # @return [Any] Fully allocated processed_object
    #
    # @api private
    # @since 0.5.0
    def call(processed_object, processed_klass, parameters, options)
      new(processed_object, processed_klass, parameters, options).call
    end
  end

  # @param processed_object [Any]
  # @param processed_klass [Class]
  # @param parameters [Array<Any>]
  # @param options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize(processed_object, processed_klass, parameters, options)
    @processed_object = processed_object
    @processed_klass = processed_klass
    @parameters = parameters
    @options = options
  end

  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  def call
    processed_object.tap do
      prevent_parameters_incomparability
      initialize_parameters
      initialize_options
      call_original_methods
      invoke_additional_initialization_steps
    end
  end

  private

  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  attr_reader :processed_object

  # @return [Class]
  #
  # @api private
  # @since 0.5.0
  attr_reader :processed_klass

  # @return [Array<Any>]
  #
  # @api private
  # @since 0.5.0
  attr_reader :parameters

  # @return [Hash<Symbol,Any>]
  #
  # @api private
  # @since 0.5.0
  attr_reader :options

  # An array of the required option attribute names (parameters without default values)
  #
  # @return [Array<Symbol>]
  #
  # @api private
  # @since 0.5.0
  def required_options
    processed_klass.__options__.each.reject(&:has_default_value?).map(&:name)
  end

  # @return [Integer]
  #
  # @api private
  # @since 0.5.0
  def required_attributes_count
    processed_klass.__params__.size
  end

  # @return [void]
  #
  # @raise [SmartCore::Initializer::AttributeError]
  # @raise [SmartCore::Initializer::ParameterError]
  # @raise [SmartCore::Initializer::OptionError]
  #
  # @api private
  # @since 0.5.0
  def prevent_parameters_incomparability
    raise(
      SmartCore::Initializer::ParameterError,
      "Wrong number of parameters " \
      "(given #{parameters.size}, expected #{required_attributes_count})"
    ) unless parameters.size == required_attributes_count

    missing_options = required_options.reject { |option| options.key?(option) }

    raise(
      SmartCore::Initializer::OptionError,
      "Missing options: :#{missing_options.join(', :')}"
    ) unless missing_options.empty?
  end

  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize_parameters
    parameter_names = processed_klass.__params__.map(&:name)
    parameter_pairs = Hash[parameter_names.zip(parameters)]

    parameter_pairs.each_pair do |parameter_name, parameter_value|
      processed_object.instance_variable_set("@#{parameter_name}", parameter_value)
    end
  end

  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize_options
    processed_klass.__options__.each do |option|
      option_name  = option.name
      option_value = options.fetch(option_name) { option.default_value }

      processed_object.instance_variable_set("@#{option_name}", option_value)
    end
  end

  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def invoke_additional_initialization_steps
    processed_klass.__initialization_extensions__.each do |extension|
      extension.call(processed_object)
    end
  end

  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def call_original_methods
    processed_object.send(:initialize, *parameters, **options)
  end
end
