# frozen_string_literal: true

class SmartCore::Validator
  class ErrorSet
    def initialize
      @errors = Set.new
      @access_lock = Mutex.new
    end

    # @param error_code [Symbol, String]
    # @return [void]
    #
    # @raise [SmartCore::Validator::IncorrectErrorCodeError]
    #
    # @api private
    # @since 0.1.0
    def add_error(error_code)
      thread_safe do
        raise IncorrectErrorCodeError unless error_code.is_a?(Symbol)
        errors << error_code
      end
    end

    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def empty?
      thread_safe { errors.empty? }
    end

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def clear
      thread_safe { errors.clear }
    end

    # @return [Array<Symbol, String>]
    #
    # @api private
    # @since 0.1.0
    def error_codes
      thred_safe { errors.to_a }
    end

    private

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
