# frozen_string_literal: true

class SmartCore::Validator
  # @api private
  # @since 0.1.0
  class Invoker
    # @return [SmartCore::Validator::Invoker::Error]
    #
    # @api private
    # @since 0.4.0
    Error = Class.new(StandardError)

    # @return [SmartCore::Validator::Invoker::StopValidationError]
    #
    # @api private
    # @since 0.4.0
    StopValidationError = Class.new(Error)

    class << self
      # @param validator [SmartCore::Validator]
      # @param validating_method [Symbol, String]
      # @return [SmartCore::Validator::ErrorSet]
      #
      # @api private
      # @since 0.1.0
      def call(validator, validating_method)
        new(validator).call(validating_method)
      end
    end

    # @return [SmartCore::Validator]
    #
    # @api private
    # @since 0.1.0k
    attr_reader :validator

    # @param validator [SmartCore::Validator]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(validator)
      @validator = validator
      @access_lock = Mutex.new
    end

    # @param validating_method [String, Symbol]
    # @return [SmartCore::Validator::ErrorSet]
    #
    #
    # @api private
    # @since 0.1.0
    def call(validating_method)
      thread_safe do
        ErrorSet.new.tap do |outer_errors|
          begin
            extended_validator(outer_errors).send(validating_method)
          rescue StopValidationError
          end
        end
      end
    end

    private

    # Creates new validator object cloned from the original validator object
    # with the new functionality:
    #   - error code interception;
    #   - soft quit from the original method immidietly;
    #
    # @param outer_errors [SmartCore::Validator::ErrorSet]
    # @return [SmartCore::Validator]
    #
    # @raise [SmartCore::Validator::Invoker::StopValidationError]
    #
    # @api private
    # @since 0.1.0
    def extended_validator(outer_errors)
      validator.dup.tap do |validator_clone|
        validator_clone.define_singleton_method(:error) do |error_code|
          outer_errors.add_error(error_code)
        end

        validator_clone.define_singleton_method(:fatal) do |error_code|
          outer_errors.add_error(error_code)
          raise StopValidationError
        end
      end
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
