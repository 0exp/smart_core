# frozen_string_literal: true

class SmartCore::Container
  # @api public
  # @since 0.7.0
  Error = Class.new(SmartCore::Error)

  # @api public
  # @since 0.7.0
  ArgumentError = Class.new(SmartCore::ArgumentError)

  # @api public
  # @since 0.7.0
  IncompatibleEntityNameError = Class.new(ArgumentError)

  # @see SmartCore::Container::Registry
  #
  # @api public
  # @since 0.7.0
  FrozenRegistryError = Class.new(SmartCore::FrozenError)

  # @see SmartCore::Container::Registry
  #
  # @api public
  # @since 0.7.0
  NonexistentEntityError = Class.new(Error)

  # @see SmartCore::Container::DependencyCompatability::General
  # @see SmartCore::Container::DependencyCompatability::Definition
  # @see SmartCore::Container::DependencyCompatability::Registry
  #
  # @api public
  # @since 0.7.0
  DependencyOverNamespaceOverlapError = Class.new(Error)

  # @see SmartCore::Container::DependencyCompatability::General
  # @see SmartCore::Container::DependencyCompatability::Definition
  # @see SmartCore::Container::DependencyCompatability::Registry
  #
  # @api public
  # @since 0.7.0
  NamespaceOverDependencyOverlapError = Class.new(Error)
end
