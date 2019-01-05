# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Validator::Commands::WorkWithNestedsMixin
  # @param validator [SmartCore::Validator]
  # @param nested_validations [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def check_nested_validations(validator, nested_validations)
    nested_validator = build_nested_validator(validator, nested_validations)

    unless nested_validator.valid?
      validator.__append_errors__(nested_validator.__validation_errors__)
    end
  end

  # @param validator [SmartCore::Validator]
  # @param nested_validations [Proc]
  # @return [SmartCore::Validator]
  #
  # @api private
  # @since 0.1.0
  def build_nested_validator(validator, nested_validations)
    Class.new(validator.class).tap do |klass|
      klass.clear_commands
      klass.instance_eval(&nested_validations)
    end.new(**validator.__attributes__)
  end

  # @param validator [SmartCore::Validator]
  # @param another_validating_klass [Class<SmartCore::Validator>]
  # @return [SmartCore::Validator]
  #
  # @api private
  # @since 0.1.0
  def build_sub_validator(validator, another_validating_klass)
    another_validating_klass.new(**validator.__attributes__)
  end
end
