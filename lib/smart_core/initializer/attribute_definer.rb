# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Initializer::AttributeDefiner
  # @param processed_klass [Class]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize(processed_klass)
    @processed_klass = processed_klass
    @definition_lock = Mutex.new
  end

  # @param param_name [Symbol, String]
  # @param param_type [String, Symbol]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def define_param(param_name, param_type = :any)
    thread_safe do
      parameter = build_attribute(param_name, param_type)
      prevent_intersection_with_already_defined_option(parameter)
      append_parameter(parameter)
    end
  end

  # @param param_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def define_params(*param_names)
    thread_safe do
      parameters = param_names.map do |param_name|
        build_attribute(param_name).tap do |parameter|
          prevent_intersection_with_already_defined_option(parameter)
        end
      end

      parameters.each { |parameter| append_parameter(parameter) }
    end
  end

  # @param option_name [Symbol, String]
  # @param option_type [String, Symbol]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def define_option(option_name, option_type = :any, **options)
    thread_safe do
      option = build_attribute(option_name, option_type, **options)
      prevent_intersection_with_already_defined_param(option)
      append_option(option)
    end
  end

  # @param option_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def define_options(*option_names)
    thread_safe do
      options = option_names.map do |option_name|
        build_attribute(option_name).tap do |option|
          prevent_intersection_with_already_defined_param(option)
        end
      end

      options.each { |option| append_option(option) }
    end
  end

  private

  # @return [Class]
  #
  # @api private
  # @since 0.5.0
  attr_reader :processed_klass

  # @param attribute_name [Symbol, String]
  # @param attribute_type [String, Symbol]
  # @param attribute_options [Hash<Symbol,Any>]
  # @return [SmartCore::Initializer::Attribute]
  #
  # @api private
  # @since 0.5.0
  def build_attribute(attribute_name, attribute_type = :any, **attribute_options)
    SmartCore::Initializer::Attribute.new(
      attribute_name,
      attribute_type,
      **attribute_options
    )
  end

  # @param parameter [SmartCore::Initializer::Attribute]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def append_parameter(parameter)
    processed_klass.__params__ << parameter
    processed_klass.send(:attr_reader, parameter.name)
  end

  # @param option [SmartCore::Initializer::Attribute]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def append_option(option)
    processed_klass.__options__ << option
    processed_klass.send(:attr_reader, option.name)
  end

  # @param parameter [SmartCore::Initializer::Attribute]
  # @return [void]
  #
  # @raise [SmartCore::Initializer::OptionOverlapError]
  #
  # @api private
  # @since 0.5.0
  def prevent_intersection_with_already_defined_option(parameter)
    if processed_klass.__options__.conflicts_with?(parameter)
      raise(
        SmartCore::Initializer::OptionOverlapError,
        "You have already defined option with :#{parameter.name} name"
      )
    end
  end

  # @param option [SmartCore::Initializer::Attribute]
  # @return [void]
  #
  # @raise [SmartCore::Initializer::ParamOverlapError]
  #
  # @api private
  # @since 0.5.0
  def prevent_intersection_with_already_defined_param(option)
    if processed_klass.__params__.conflicts_with?(option)
      raise(
        SmartCore::Initializer::ParamOverlapError,
        "You have already defined param with :#{option.name} name"
      )
    end
  end

  # @param block [Proc]
  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  def thread_safe(&block)
    @definition_lock.synchronize(&block)
  end
end
