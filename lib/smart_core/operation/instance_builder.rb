# frozen_string_literal: true

class SmartCore::Operation::InstanceBuilder
  class << self
    # @param operation_object [SmartCore::Operation]
    # @param operation_klass [Class<SmartCore::Operation>]
    # @param attributes [Array<Any>]
    # @param options [Hash<Symbol,Any>]
    # @param block [Proc]
    # @return [SmartCore::Operation]
    #
    # @api private
    # @since 0.2.0
    def call(operation_object, operation_klass, attributes, options, block)
      new(operation_object, operation_klass, attributes, options, block).call
    end
  end

  # @param operation_object [SmartCore::Operation]
  # @param operation_klass [Class<SmartCore::Operation>]
  # @param attributes [Array<Any>]
  # @param options [Hash<Symbol,Any>]
  # @param block [Proc]
  # @return [SmartCore::Operation]
  #
  # @api private
  # @since 0.2.0
  def initialize(operation_object, operation_klass, attributes, options, block)
    @object     = operation_object
    @klass      = operation_klass
    @init_attrs = attributes
    @init_opts  = options
    @init_block = block
  end

  # @return [SmartCore::Operation]
  #
  # @api private
  # @since 0.2.0
  def call
  end

  private

  # @return [SmartCore::Operation]
  #
  # @api private
  # @since 0.2.0
  attr_reader :object


  # @return [Class<SmartCore::Operation>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :klass

  # @return [Array<Any>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :init_attrs


  # @return [Hash<Symbol,Any>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :init_opts

  # @return [Proc]
  #
  # @api private
  # @since 0.2.0
  attr_reader :init_block
end
