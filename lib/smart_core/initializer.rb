# frozen_string_literal: true

# @api public
# @since 0.5.0
module SmartCore::Initializer
  require_relative 'initializer/exceptions'
  require_relative 'initializer/attribute'
  require_relative 'initializer/attribute_set'
  require_relative 'initializer/attribute_definer'
  require_relative 'initializer/extension'
  require_relative 'initializer/extension_set'
  require_relative 'initializer/extension_definer'
  require_relative 'initializer/instance_builder'
  require_relative 'initializer/type'
  require_relative 'initializer/type_set'
  require_relative 'initializer/initialization_dsl'
  require_relative 'initializer/instance_attribute_accessing'

  @__type_set__ = SmartCore::Initializer::TypeSet.new
  # TODO: convertable attributes and converters (in typeset manner)

  class << self
    # @param child_klass [Class]
    # @return [void]
    #
    # @api public
    # @since 0.5.0
    def included(child_klass)
      child_klass.include(InitializationDSL)
      child_klass.include(InstanceAttributeAccessing)
    end

    # @param name [String, Symbol]
    # @param checker [Block]
    # @return [void]
    #
    # @api public
    # @since 0.5.0
    def register_type(name, &checker)
      types.register(name, checker)
    end

    # @param name [String, Symbol]
    # @return [SmartCore::Initializer::Type]
    #
    # @api private
    # @since 0.5.0
    def get_type(name)
      types.resolve(name)
    end

    # @return [SmartCore::Initializer::TypeSet]
    #
    # @api private
    # @since 0.5.0
    def types
      @__type_set__
    end
  end

  # @since 0.5.0
  register_type(:array) { |value| value.is_a?(Array) }
  # @since 0.5.0
  register_type(:hash) { |value| value.is_a?(Hash) }
  # @since 0.5.0
  register_type(:string) { |value| value.is_a?(String) }
  # @since 0.5.0
  register_type(:integer) { |value| value.is_a?(Integer) }
  # @since 0.5.0
  register_type(:float) { |value| value.is_a?(Float) }
  # @since 0.5.0
  register_type(:proc) { |value| value.is_a?(Proc) }
  # @since 0.5.0
  register_type(:numeric) { |value| value.is_a?(Numeric) }
  # @since 0.5.0
  register_type(:big_decimal) { |value| value.is_a?(BigDecimal) }
  # @since 0.5.0
  register_type(:class) { |value| value.is_a?(Class) }
  # @since 0.5.0
  register_type(:boolean) { |value| value.is_a?(TrueClass) || value.is_a?(FalseClass) }
  # @since 0.5.0
  register_type(:__any__) { true }
end
