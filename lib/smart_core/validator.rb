# frozen_string_literal: true

# @api public
# @since 0.1.0
class SmartCore::Validator
  require_relative 'validator/exceptions'
  require_relative 'validator/command_set'
  require_relative 'validator/attribute'
  require_relative 'validator/attribute_set'
  require_relative 'validator/error_set'
  require_relative 'validator/invoker'
  require_relative 'validator/commands'
  require_relative 'validator/dsl'

  # @since 0.1.0
  extend DSL

  class << self
    # @param argumants [Any]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def new(*arguments, **options)
      allocate.tap do |object|
        object.instance_variable_set(:@__validation_errors__, ErrorSet.new)
        object.instance_variable_set(:@__invokation_lock__, Mutex.new)
        object.instance_variable_set(:@__access_lock__, Mutex.new)

        attributes.each do |attribute|
          attribute_name = attribute.name

          attribute_value =
            if options.key?(attribute_name)
              options[attribute_name]
            else
              attribute.default_value
            end

          object.instance_variable_set("@#{attribute_name}", attribute_value)
        end

        object.send(:initialize, *arguments, **options)
      end
    end
  end

  # @return [SmartCore::Validator::ErrorSet]
  #
  # @api private
  # @since 0.1.0
  attr_reader :__validation_errors__

  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def initialize(*, **); end

  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  def valid?
    __thread_safe_invokation__ do
      __validation_errors__.clear
      self.class.commands.each { |command| command.call(self) }
      __validation_errors__.empty?
    end
  end

  # @return [Array<Symbol>]
  #
  # @api public
  # @since 0.1.0
  def errors
    __thread_safe_access__ do
      __validation_errors__.codes
    end
  end

  # @param error_set [SmartCore::Validator::ErrorSet]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def __append_errors__(error_set)
    __thread_safe_access__ do
      __validation_errors__.concat(error_set)
    end
  end

  # @return [Hash]
  #
  # @api private
  # @since 0.1.0
  def __attributes__
    __thread_safe_access__ do
      self.class.attributes.each_with_object({}) do |attribute, accumulator|
        accumulator[attribute.name] = instance_variable_get("@#{attribute.name}")
      end
    end
  end

  private

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def __thread_safe_invokation__
    @__invokation_lock__.synchronize { yield if block_given? }
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def __thread_safe_access__
    @__access_lock__.synchronize { yield if block_given? }
  end
end
