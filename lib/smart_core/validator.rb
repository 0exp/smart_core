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

  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def initialize
    @access_lock = Mutex.new
    @validation_errors = ErrorSet.new
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  def valid?
    thread_safe do
      validation_errors.clear
      self.class.commands.each { |command| command.call(self) }
      validation_errors.empty?
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
  def append_errors(error_set)
    validation_errors.append_errors(error_set)
  end

  private

  # @return [SmartCore::Validator::ErrorSet]
  #
  # @api private
  # @since 0.1.0
  attr_reader :validation_errors

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def thread_safe
    @access_lock.synchronize { yield if block_given? }
  end
end
