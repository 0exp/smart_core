# frozen_string_literal: true

module SmartCore::Validator::Commands
  # @api private
  # @since 0.1.0
  class ValidateWith < Base
    # @since 0.1.0
    include WorkWithNestedsMixin

    # @return [Class<SmartCore::Validator>]
    #
    # @api private
    # @since 0.1.0
    attr_reader :validating_klass

    # @return [Proc]
    #
    # @api private
    # @since 0.1.0
    attr_reader :nested_validations

    # @param validating_klass [Class<SmartCore::Validator>]
    # @param nested_validations [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(validating_klass, nested_validations)
      @validating_klass = validating_klass
      @nested_validations = nested_validations
    end

    # @param validator [SmartCore::Validator]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def call(validator)
      sub_validator = build_sub_validator(validator, validating_klass)

      if sub_validator.valid?
        check_nested_validations(validator, nested_validations)
      else
        validator.__append_errors__(sub_validator.__validation_errors__)
      end
    end
  end
end
