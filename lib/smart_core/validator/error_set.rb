# frozen_string_literal: true

class SmartCore::Validator
  # @api private
  # @since 0.1.0
  class ErrorSet
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize
      @errors = Set.new
      @access_lock = Mutex.new
    end

    # @param error_codes [Arrray<Symbol>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def add_error(error_code)
      thread_safe { store_error(error_code) }
    end

    # @param error_set [SmartCore::Validator::ErrorSet]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def append_errors(error_set)
      thread_safe { error_set.codes.each { |error_code| store_error(error_code) } }
    end

    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def empty?
      thread_safe { errors.empty? }
    end

    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def any?
      thread_safe { errors.any? }
    end

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def clear
      thread_safe { errors.clear }
    end

    # @return [Array<Symbol>]
    #
    # @api private
    # @since 0.1.0
    def codes
      thread_safe { errors.to_a }
    end

    private

    # @param error_code [Symbol]
    # @return [void]
    #
    # @raise [SmartCore::Validator::IncorrectErrorCodeError]
    #
    # @api private
    # @since 0.1.0
    def store_error(error_code)
      raise IncorrectErrorCodeError unless error_code.is_a?(Symbol)
      errors << error_code
    end

    # @return [Array<Symbol>]
    #
    # @api private
    # @since 0.1.0
    attr_reader :errors

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def thread_safe
      @access_lock.synchronize { yield if block_given? }
    end
  end
end
