# frozen_string_literal: true

# @api public
# @since 0.2.0
class SmartCore::Operation
  require_relative 'operation/exceptions'
  require_relative 'operation/attribute'
  require_relative 'operation/attribute_set'
  require_relative 'operation/attribute_dsl'
  require_relative 'operation/result'
  require_relative 'operation/success'
  require_relative 'operation/failure'

  # @since 0.2.0
  extend AttributeDSL

  class << self
    # @param arguments [Any]
    # @param options [Hash<Symbol,Any>]
    # @param block [Proc]
    # @return [Any]
    #
    # @api public
    # @since 0.2.0
    def call(*arguments, **options, &block)
      new(*arguments, **options, &block).call
    end
  end

  # @api public
  # @since 0.2.0
  def call
    Success
  end

  private

  # @param result_data [Hash<Symbol,Any>]
  # @return [SmartCore::Operation::Success]
  #
  # @api public
  # @since 0.2.0
  def Success(**result_data)
    SmartCore::Operation::Success.new(**result_data)
  end

  # @param errors [Array<Symbol|Any>]
  # @return [SmartCore::Operation::Failure]
  #
  # @api public
  # @since 0.2.0
  def Failure(*errors)
    SmartCore::Operation::Failure.new(*errors)
  end
end
