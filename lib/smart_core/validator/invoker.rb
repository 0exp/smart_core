# frozen_string_literal: true

class SmartCore::Validator
  # @api private
  # @since 0.1.0
  class Invoker
    # @return [SmartCore::Validator]
    #
    # @api private
    # @since 0.1.0
    attr_reader :validator

    # @return [SmartCore::Validator::ErrorSet]
    #
    # @api private
    # @since 0.1.0
    attr_reader :errors

    # @param validator [SmartCore::Validator]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(validator)
      @validator = validator
      @errors = ErrorSet.new
      @access_lock = Mutex.new
    end

    # @param validating_method [String, Symbol]
    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def call(validating_method)
      thread_safe do
        errors.clear
        extended_validator.send(validating_method)
        errors.empty?
      end
    end

    private

    # @param error_code [Symbol]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def error(error_code)
      errors.add_error(error_code)
    end

    # Creates new validator object cloned from the original validator object
    # with the new functionality: error code interception.
    #
    # @return [SmartCore::Validator]
    #
    # @api private
    # @since 0.1.0
    def extended_validator
      invoker_context = self

      validator.dup.tap do |validator_clone|
        validator_clone.define_singleton_method(:error) do |error_code|
          invoker_context.send(:error, error_code)
        end
      end
    end

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def thread_safe
      @access_lock.synchronize { yield if block_given? }
    end
  end
end
