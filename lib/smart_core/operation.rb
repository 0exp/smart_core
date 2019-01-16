# frozen_string_literal: true

# @api public
# @since 0.2.0
class SmartCore::Operation
  require_relative 'operation/exceptions'
  require_relative 'operation/attribute'
  require_relative 'operation/attribute_set'
  require_relative 'operation/result'
  require_relative 'operation/success'
  require_relative 'operation/failure'
  require_relative 'operation/instance_builder'
  require_relative 'operation/attribute_definer'
  require_relative 'operation/initialization_dsl'

  # @since 0.2.0
  include InitializationDSL

  class << self
    # @param arguments [Any]
    # @param options [Hash<Symbol,Any>]
    # @param block [Proc]
    # @return [SmartCore::Operation::Success, SmartCore::Operation::Failure]
    #
    # @api public
    # @since 0.2.0
    def call(*arguments, **options, &block)
      new(*arguments, **options, &block).call
    end
  end

  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize(*, **, &block); end

  # @return [SmartCore::Operation::Success, SmartCore::Operation::Failure]
  #
  # @api public
  # @since 0.2.0
  def call
    Success()
  end

  private

  # @param result_data [Hash<Symbol,Any>]
  # @return [SmartCore::Operation::Success]
  #
  # @api public
  # @since 0.2.0
  def Success(**result_data) # rubocop:disable Naming/MethodName
    SmartCore::Operation::Success.new(**result_data)
  end

  # @param errors [Array<Symbol|Any>]
  # @return [SmartCore::Operation::Failure]
  #
  # @api public
  # @since 0.2.0
  def Failure(*errors) # rubocop:disable Naming/MethodName
    SmartCore::Operation::Failure.new(*errors)
  end
end
