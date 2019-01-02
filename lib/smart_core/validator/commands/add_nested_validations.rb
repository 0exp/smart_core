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
      errors = SmartCore::Validator::Invoker.call(validator, validating_method)

      if errors.empty?
        check_nested_validations(validator)
      else
        validator.__append_errors__(errors)
      end
    end

    private

    # @param validator [SmartCore::Validator]
    # @return [void]
    #
    # @api private
    # @since 0.10.
    def check_nested_validations(validator)
      nested_validator = build_nested_validator(validator)

      unless nested_validator.valid?
        validator.__append_errors__(nested_validator.__validation_errors__)
      end
    end

    # @param validator [SmartCore::Validator]
    # @return [SmartCore::Validator]
    #
    # @api private
    # @since 0.1.0
    def build_nested_validator(validator)
      Class.new(validator.class).tap do |klass|
        klass.clear_commands
        klass.instance_eval(&nested_validations)
      end.new(**validator.__attributes__)
    end
  end
end
