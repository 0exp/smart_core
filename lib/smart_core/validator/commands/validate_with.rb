# frozen_string_literal: true

module SmartCore::Validator::Commands
  # @api private
  # @since 0.1.0
  class ValidateWith < Base
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
    def call(validator) # TODO: может есть возможность отнаследоваться от AddNestedValidations
      sub_validator = validating_klass.new(**validator.__attributes__)

      unless sub_validator.valid?
        validator.__append_errors__(sub_validator.__validation_errors__)

        nested_validator_klass = Class.new(validator.class).tap do |klass|
          klass.clear_commands
          klass.instance_eval(&nested_validations)
        end

        nested_validator = nested_validator_klass.new(**validator.__attributes__)

        unless nested_validator.valid?
          validator.__append_errors__(nested_validator.__validation_errors__)
        end
      end
    end
  end
end
