# frozen_string_literal: true

# @api public
# @since 0.1.0
class SmartCore::Validator
  require_relative 'validator/exceptions'
  require_relative 'validator/command_set'
  require_relative 'validator/error_set'
  require_relative 'validator/commands'
  require_relative 'validator/dsl'

  # @since 0.1.0
  extend DSL

  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def initialize
    @error_set = ErrorSet.new
    @access_lock = Mutex.new
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  def valid?
    thread_safe do
      error_set.clear
      self.class.commands.each { |command| command.call(self) }
      error_set.empty?
    end
  end

  def errors
    thread_safe { error_set.error_codes }
  end

  private

  # @return [ErrorSet]
  #
  # @api private
  # @since 0.1.0
  attr_reader :error_set

  # @param error_code [Symbol, String]
  # @return [void]
  #
  # @see SmartCore::Validator::ErrorSet#add_error
  #
  # @api public
  # @since 0.1.0
  def error(error_code)
    error_set.add_error(error_code)
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def thread_safe
    @access_lock.synchronize { yield if block_given? }
  end
end
