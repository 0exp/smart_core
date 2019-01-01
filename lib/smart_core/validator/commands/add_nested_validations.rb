# frozen_string_literal: true

module SmartCore::Validator::Commands
  # @api private
  # @since 0.1.0
  class AddNestedValidations < Base
    # @return [Symbol, String]
    #
    # @api private
    # @since 0.1.0
    attr_reader :validating_method

    # @return [Proc]
    #
    # @api private
    # @since 0.1.0
    attr_reader :nested_validations

    # @param validating_method [Symbol, String]
    # @param nested_validations [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(validating_method, nested_validations)
      @validating_method  = validating_method
      @nested_validations = nested_validations
    end

    # @param validator [SmartCore::Validator]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def call(validator)
      invoker = SmartCore::Validator::Invoker.new(validator)
      invoker.call(validating_method)
      validator.__append_errors__(invoker.errors)

      if invoker.errors.empty?
        nested_validator = Class.new(validator.class).tap do |klass|
          klass.clear_commands
          klass.instance_eval(&nested_validations)
        end.new

        unless nested_validator.valid?
          validator.__append_errors__(nested_validator.send(:__validation_errors__))
        end
      end
    end
  end
end
