# frozen_string_literal: true

# @api public
# @since 0.1.0
class SmartCore::Validator
  require_relative 'validator/exceptions'
  require_relative 'validator/command_set'
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
    def new(*arguments)
      allocate.tap do |object|
        object.instance_variable_set(:@__access_lock__, Mutex.new)
        object.instance_variable_set(:@__validation_errors__, ErrorSet.new)
        object.send(:initialize, *arguments)
      end
    end
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  def valid?
    __thread_safe__ do
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
    validation_errors.codes
  end

  # @param error_set [SmartCore::Validator::ErrorSet]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def __append_errors__(error_set)
    __validation_errors__.append_errors(error_set)
  end

  private

  # @return [SmartCore::Validator::ErrorSet]
  #
  # @api private
  # @since 0.1.0
  attr_reader :__validation_errors__

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def __thread_safe__
    @__access_lock__.synchronize { yield if block_given? }
  end
end
