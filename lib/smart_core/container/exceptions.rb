# frozen_string_literal: true

class SmartCore::Container
  # @api public
  # @since 0.5.0
  Error = Class.new(SmartCore::Error)

  # @api public
  # @since 0.5.0
  ArgumentError = Class.new(SmartCore::ArgumentError)

  # @api public
  # @since 0.5.0
  NamespaceOverlapError = Class.new(Error)

  # @api public
  # @since 0.5.0
  DependencyOverlapError = Class.new(Error)
end
