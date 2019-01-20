# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Operation::InstanceBuilder
  class << self
    # @param operation_object [SmartCore::Operation]
    # @param operation_klass [Class<SmartCore::Operation>]
    # @param parameters [Array<Any>]
    # @param options [Hash<Symbol,Any>]
    # @return [SmartCore::Operation]
    #
    # @api private
    # @since 0.2.0
    def call(operation_object, operation_klass, parameters, options)
      new(operation_object, operation_klass, parameters, options).call
    end
  end

  # @param operation_object [SmartCore::Operation]
  # @param operation_klass [Class<SmartCore::Operation>]
  # @param parameters [Array<Any>]
  # @param options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize(operation_object, operation_klass, parameters, options)
    @operation_object = operation_object
    @operation_klass = operation_klass
    @parameters = parameters
    @options = options
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
      make_operation_caller_yieldable
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

  # An array of the required option attribute names (parameters without default values)
  #
  # @return [Array<Symbol>]
  #
  # @api private
  # @since 0.2.0
  def required_options
    operation_klass.__options__.each.reject(&:has_default_value?).map(&:name)
  end

  # @return [Integer]
  #
  # @api private
  # @since 0.2.0
  def required_attributes_count
    operation_klass.__params__.size
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
    raise(
      SmartCore::Operation::ParameterError,
      "Wrong number of parameters " \
      "(given #{parameters.size}, expected #{required_attributes_count})"
    ) unless parameters.size == required_attributes_count

    missing_options = required_options.reject { |option| options.key?(option) }

    raise(
      SmartCore::Operation::OptionError,
      "Missing options: :#{missing_options.join(', :')}"
    ) unless missing_options.empty?
  end

  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize_parameters
    parameter_names = operation_klass.__params__.map(&:name)
    parameter_pairs = Hash[parameter_names.zip(parameters)]

    parameter_pairs.each_pair do |parameter_name, parameter_value|
      operation_object.instance_variable_set("@#{parameter_name}", parameter_value)
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

      operation_object.instance_variable_set("@#{option_name}", option_value)
    end
  end

  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def call_original_methods
    operation_object.send(:initialize, *parameters, **options)
  end

  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def make_operation_caller_yieldable
    operation_object.singleton_class.prepend(Module.new do
      def call
        super.tap { |result| yield(result) if block_given? }
      rescue SmartCore::Operation::FatalError => error
        # NOTE: returns SmartCore::Operation::Fatal instance
        error.__operation_result__.tap { |result| yield(result) if block_given? }
      end
    end)
  end
end
