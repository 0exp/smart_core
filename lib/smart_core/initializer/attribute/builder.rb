# frozen_string_literal: true

class SmartCore::Initializer::Attribute
  # @api private
  # @since 0.5.0
  module Builder
    class << self
      # @param name [String, Symbol]
      # @option type [Symbol]
      # @option privacy [Symbol, String]
      # @param options [Hash<Symbol,Any>]
      #   - :default (see SmartCore::Initializer::Attribute#initializer)
      # @return [SmartCore::Initializer::Attribute]
      #
      # @raise [SmartCore::Initializer::IncorrectAttributeNameError]
      # @raise [SmartCore::Initializer::UnregisteredTypeError]
      # @raise [SmartCore::Initializer::AttributeError]
      #
      # @api private
      # @since 0.5.0
      def build(name, type: :__any__, privacy: :default, **options)
        name    = represent_name_attr(name)
        type    = represent_type_attr(type)
        privacy = represent_privacy_attr(privacy)

        SmartCore::Initializer::Attribute.new(name, type, privacy, **options)
      end

      private

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
