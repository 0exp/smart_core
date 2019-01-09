# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Validator
  class InstanceBuilder
    class << self
      # @param validator_object [SmartCore::Validator]
      # @param validator_klass [Class<SmartCore::Validator>]
      # @param arguments [Array<Any>]
      # @param options [Hash<Symbol,Any>]
      # @param block [Proc]
      # @return [SmartCore::Validator]
      #
      # @api private
      # @since 0.2.0
      def call(validator_object, validator_klass, arguments, options, block)
        new(validator_object, validator_klass, arguments, options, block).call
      end
    end

    # @param validator_object [SmartCore::Validator]
    # @param validator_klass [Class<SmartCore::Validator>]
    # @param arguments [Array<Any>]
    # @param options [Hash<Symbol,Any>]
    # @param block [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.2.0
    def initialize(validator_object, validator_klass, arguments, options, block)
      @validator_object = validator_object
      @validator_klass = validator_klass
      @arguments = arguments
      @options = options
      @block = block
    end

    # @return [SmartCore::Validator]
    #
    # @api private
    # @since 0.2.0
    def call
      validator_object.tap do
        initialize_core_attributes
        initialize_custom_attributes
        invoke_original_methods
      end
    end

    private

    # @return [SmartCore::Validator]
    #
    # @api private
    # @since 0.2.0
    attr_reader :validator_object

    # @return [Class<SmartCore::Validator>]
    #
    # @api private
    # @since 0.2.0
    attr_reader :validator_klass

    # @return [Array<Any>]
    #
    # @api private
    # @since 0.2.0
    attr_reader :arguments

    # @return [Hash<Symbol,Any>]
    #
    # @api private
    # @since 0.2.0
    attr_reader :options

    # @return [Proc]
    #
    # @api private
    # @since 0.2.0
    attr_reader :block

    # @return [void]
    #
    # @api private
    # @since 0.2.0
    def initialize_core_attributes
      validator_object.instance_variable_set(:@__validation_errors__, ErrorSet.new)
      validator_object.instance_variable_set(:@__invokation_lock__, Mutex.new)
      validator_object.instance_variable_set(:@__access_lock__, Mutex.new)
    end

    # @return [void]
    #
    # @api private
    # @since 0.2.0
    def initialize_custom_attributes
      validator_klass.attributes.each do |attribute|
        attribute_name  = attribute.name
        attribute_value = options.fetch(attribute_name) { attribute.default_value }

        validator_object.instance_variable_set("@#{attribute_name}", attribute_value)
      end
    end

    # @return [void]
    #
    # @api private
    # @since 0.2.0
    def invoke_original_methods
      validator_object.send(:initialize, *arguments, **options, &block)
    end
  end
end
