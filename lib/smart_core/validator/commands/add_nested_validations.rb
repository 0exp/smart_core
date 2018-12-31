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
      @validating_method = validating_method
      @nested_validations = nested_validations
    end

    # @param validator [SmartCore::Validator]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def call(validator)

    end
  end
end
