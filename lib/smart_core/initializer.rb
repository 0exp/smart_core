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
  require_relative 'initializer/initialization_dsl'

  class << self
    # @param child_klass [Class]
    # @return [void]
    #
    # @api public
    # @since 0.5.0
    def included(child_klass)
      child_klass.include(InitializationDSL)
    end
  end
end
