# frozen_string_literal: true

# @api public
# @since 0.2.0
class SmartCore::Operation
  require_relative 'operation/exceptions'
  require_relative 'operation/state'
  require_relative 'operation/step'
  require_relative 'operation/step_set'
  require_relative 'operation/result'
  require_relative 'operation/success'
  require_relative 'operation/failure'
  require_relative 'operation/fatal'
  require_relative 'operation/custom'
  require_relative 'operation/result_interface'
  require_relative 'operation/instance_builder'

  # @since 0.5.0
  include SmartCore::Initializer
  # @since 0.6.0
  include SmartCore::Operation::ResultInterface

  # @since 0.5.0
  extend_initialization_flow do |operation|
    SmartCore::Operation::InstanceBuilder.call(operation)
  end

  class << self
    # @param arguments [Any]
    # @param options [Hash<Symbol,Any>]
    # @param block [Proc]
    # @return [SmartCore::Operation::Success]
    # @return [SmartCore::Operation::Failure]
    # @return [SmartCore::Operation::Fatal]
    #
    # @api public
    # @since 0.2.0
    def call(*arguments, **options, &block)
      new(*arguments, **options).call(&block)
    end
  end

  # @return [SmartCore::Operation::Success]
  # @return [SmartCore::Operation::Failure]
  # @return [SmartCore::Operation::Fatal]
  # @return [Any]
  #
  # @api public
  # @since 0.2.0
  def call
    Success()
  end
end
