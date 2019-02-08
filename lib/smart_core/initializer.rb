# frozen_string_literal: true

# @api public
# @since 0.5.0
module SmartCore::Initializer
  require_relative 'initializer/exceptions'
  require_relative 'initializer/attribute'
  require_relative 'initializer/attribute_set'
  require_relative 'initializer/attribute_definer'
  require_relative 'initializer/instance_builder'
  require_relative 'initializer/initialization_dsl'
end
