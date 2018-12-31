# frozen_string_literal: true

class SmartCore::Validator
  class ErrorSet
    # @return [Array<Symbol>]
    #
    # @api private
    # @since 0.1.0
    attr_reader :errors

    def initialize
      @errors = []
      @access_lock = Mutex.new
    end

    # @param error_code [Symbol, String]
    # @return [void]
    #
    # @raise [SmartCore::Validator::IncorrectErrorCodeError]
    #
    # @api private
    # @since 0.1.0
    def error(error_code)
      thread_safe do
        raise IncorrectErrorCodeError unless error_code.is_a?(Symbol)
        errors << error_code
      end
    end

    private

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def thread_safe
      @access_lock.synchronize { yield if block_given? }
    end
  end
end
