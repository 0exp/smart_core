# frozen_string_literal: true

module SmartCore::Validator::Commands
  # @api private
  # @since 0.1.0
  class AddValidation < Base
    # @return [Symbol, String]
    #
    # @api private
    # @since 0.1.0
    attr_reader :validating_method

    # @param validating_method [String, Symbol]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(validating_method)
      @validating_method = validating_method
    end

    # @param validator [SmartCore::Validator]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def call(validator)
      validator.send(validating_method)
    end
  end
end
