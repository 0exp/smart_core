# frozen_string_literal: true

module SmartCore::Validator::Commands
  # @api private
  # @since 0.1.0
  class AddNestedValidations < Base
    # @since 0.1.0
    include WorkWithNestedsMixin

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
      @validating_method = validating_method
      @nested_validations = nested_validations
    end

    # @param validator [SmartCore::Validator]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def call(validator)
      errors = SmartCore::Validator::Invoker.call(validator, validating_method)

      if errors.empty?
        check_nested_validations(validator, nested_validations)
      else
        validator.__append_errors__(errors)
      end
    end
  end
end
