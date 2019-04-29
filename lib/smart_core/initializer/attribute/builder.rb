# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Initializer::Attribute
  module Builder
    class << self
      # @return [Proc]
      #
      # @api private
      # @since 0.5.0
      DEFAULT_FINALIZE = -> (value) { value }.freeze

      # @param name [String, Symbol]
      # @option type [Symbol]
      # @option privacy [Symbol, String]
      # @param options [Hash<Symbol,Any>]
      #   - :default (see SmartCore::Initializer::Attribute#initialize)
      #   - :finalize (see SmartCore::Initializer::Attribute#initialize)
      # @return [SmartCore::Initializer::Attribute]
      #
      # @raise [SmartCore::Initializer::IncorrectAttributeNameError]
      # @raise [SmartCore::Initializer::UnregisteredTypeError]
      # @raise [SmartCore::Initializer::AttributeError]
      #
      # @api private
      # @since 0.5.0
      def build(name, type: :__any__, privacy: :default, finalize: DEFAULT_FINALIZE, **options)
        name      = represent_name_attr(name)
        type      = represent_type_attr(type)
        privacy   = represent_privacy_attr(privacy)
        finalizer = represent_finalizer_attr(finalize)

        SmartCore::Initializer::Attribute.new(name, type, privacy, finalizer, **options)
      end

      private

      # @param finalize [Proc, String, Symbol]
      # @return [SmartCore::Initializer::Attribute::ValueFinalizer::Lambda]
      # @return [SmartCore::Initializer::Attribute::ValueFinalizer::Method]
      #
      # @api private
      # @since 0.5.0
      def represent_finalizer_attr(finalize)
        raise(
          SmartCore::Initializer::IncompatibleFinalizerTypeError,
          ':finalize should be a symbol/string or a proc/lambda'
        ) unless finalize.is_a?(Proc) || finalize.is_a?(Symbol) || finalize.is_a?(String)

        ValueFinalizer.build(finalize)
      end

      # @param privacy [Symbol, String]
      # @return [Symbol]
      #
      # @api private
      # @since 0.5.0
      def represent_privacy_attr(privacy)
        begin
          PRIVACY_MODES.fetch(privacy.to_sym)
        rescue KeyError
          raise(
            SmartCore::Initializer::UnsupportedAttributePrivacyError,
            "Required :#{privacy} privacy mode is not supported!"
          )
        end
      end

      # @param name [Symbol, String]
      # @return [Symbol, String]
      #
      # @api private
      # @since 0.5.0
      def represent_name_attr(name)
        name.tap do |value|
          raise(
            SmartCore::Initializer::IncorrectAttributeNameError,
            'Attribute name should be a symbol or a string'
          ) unless value.is_a?(Symbol) || value.is_a?(String)
        end
      end

      # @param type [String]
      # @return [Symbol]
      #
      # @api private
      # @since 0.5.0
      def represent_type_attr(type)
        type.tap do |value|
          raise(
            SmartCore::Initializer::UnregisteredTypeError,
            "type :#{value} is not registered!"
          ) unless SmartCore::Initializer.types.has_type?(value)
        end
      end
    end
  end
end
