# frozen_string_literal: true

module SmartCore::Initializer::Attribute::ValueFinalizer
  require_relative 'value_finalizer/lambda'
  require_relative 'value_finalizer/method'

  class << self
    # @param finalize [Proc, String, Symbol]
    # @return [SmartCore::Initializer::Attribute::ValueFinalizer::Lambda]
    # @return [SmartCore::Initializer::Attribute::ValueFinalizer::Method]
    #
    # @api private
    # @since 0.5.0
    def build(finalize)
      case finalize
      when Symbol, String
        Method.new(finalize)
      when Proc
        Lambda.new(finalize)
      end
      # NOTE: other variants are impossible (by SmartCore::Initializer::Attribute::Builder)
    end
  end
end
