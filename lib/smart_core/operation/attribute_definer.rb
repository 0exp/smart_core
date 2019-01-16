# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Operation::AttributeDefiner
  # @param operation_klass [Class<SmartCore::Operation>]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize(operation_klass)
    @operation_klass = operation_klass
    @definition_lock = Mutex.new
  end

  # @param param_name [Symbol, String]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def define_param(param_name)
    thread_safe do
      parameter = build_attribute(param_name)
      prevent_intersection_with_already_defined_option(parameter)
      append_parameter(parameter)
    end
  end

  # @param param_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
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
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def define_option(option_name, **options)
    thread_safe do
      option = build_attribute(option_name, **options)
      prevent_intersection_with_already_defined_param(option)
      append_option(option)
    end
  end

  # @param option_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
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

  # @return [Class<SmartCore::Operation>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :operation_klass

  # @return [Mutex]
  #
  # @api private
  # @since 0.2.0
  attr_reader :definition_lock

  # @param attribute_name [Symbol, String]
  # @param attribute_options [Hash<Symbol,Any>]
  # @return [SmartCore::Operation::Attribute]
  #
  # @api private
  # @since 0.2.0
  def build_attribute(attribute_name, **attribute_options)
    SmartCore::Operation::Attribute.new(attribute_name, **attribute_options)
  end

  # @param parameter [SmartCore::Operation::Attribute]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def append_parameter(parameter)
    operation_klass.__params__ << parameter
    operation_klass.send(:attr_reader, parameter.name)
  end

  # @param option [SmartCore::Operation::Attribute]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def append_option(option)
    operation_klass.__options__ << option
    operation_klass.send(:attr_reader, option.name)
  end

  # @param parameter [SmartCore::Operation::Attribute]
  # @return [void]
  #
  # @raise [???]
  #
  # @api private
  # @since 0.2.0
  def prevent_intersection_with_already_defined_option(parameter)
    # TODO: implement
  end

  # @param option [SmartCore::Operation::Attribute]
  # @return [void]
  #
  # @raise [???]
  #
  # @api private
  # @since 0.2.0
  def prevent_intersection_with_already_defined_param(option)
    # TODO: implement
  end

  # @param block [Proc]
  # @return [Any]
  #
  # @api private
  # @since 0.2.0
  def thread_safe(&block)
    definition_lock.synchronize(&block)
  end
end
