# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Validator
  module DSL
    class << self
      # @param base_klass [Class]
      # @return [void]
      #
      # @api private
      # @since 0.1.0
      def extended(base_klass)
        base_klass.instance_variable_set(:@commands, CommandSet.new)

        base_klass.singleton_class.prepend(Module.new do
          def inherited(child_klass)
            child_klass.instance_variable_set(:@commands, CommandSet.new)
            child_klass.commands.concat(commands)
          end
        end)
      end
    end

    # @return [SmartCore::Validator::CommandSet]
    #
    # @api private
    # @since 0.1.0
    def commands
      @commands
    end

    # @param validating_method [Symbol, String]
    # @param nested_validations [Proc]
    # @return [void]
    #
    # @see SmartCore::Validator::Commands::AddValidation
    # @see SmartCore::Validator::Commands::AddNestedValidations
    #
    # @api public
    # @since 0.1.0
    def validate(validating_method, &nested_validations)
      if block_given?
        commands << Commands::AddNestedValidations.new(validating_method, nested_validations)
      else
        commands << Commands::AddValidation.new(validating_method)
      end
    end

    # @param validating_klass [Class<SmartCore::Validator>]
    # @param nested_validations [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def validate_with(validating_klass, &nested_validations)
      commands << Commands::ValidateWith.new(validating_klass, &nested_validations)
    end
  end
end

