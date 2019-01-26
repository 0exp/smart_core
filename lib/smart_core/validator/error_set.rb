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
    def concat(error_set)
      thread_safe do
        error_set.codes.each do |error_code|
          store_error(error_code)
        end
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

    # @return [Array<Symbol>]
    #
    # @api private
    # @since 0.1.0
    def codes
      thread_safe { errors.to_a }
    end

    private

    # @return [Array<Symbol>]
    #
    # @api private
    # @since 0.1.0
    attr_reader :errors

    # @param error_code [Symbol, String]
    # @return [void]
    #
    # @raise [SmartCore::Validator::IncorrectErrorCodeError]
    #
    # @api private
    # @since 0.1.0
    def store_error(error_code)
      # NOTE: think about the any type of error codes
      unless error_code.is_a?(Symbol) || error_code.is_a?(String)
        raise IncorrectErrorCodeError, 'Error code should be a symbol or a string'
      end

      errors << error_code.to_sym
    end

    # @param block [Proc]
    # @return [Any]
    #
    # @api private
    # @since 0.1.0
    def thread_safe(&block)
      @access_lock.synchronize(&block)
    end
  end
end
