# frozen_string_literal: true

class QuantumCore::Container
  # @api public
  # @since 0.1.0
  Error = Class.new(QuantumCore::Error)

  # @see QuantumCore::Container::Registry
  #
  # @api public
  # @since 0.1.0
  FrozenRegistryError = Class.new(QuantumCore::FrozenError)

  # @see QuantumCore::Container::Registry
  #
  # @api public
  # @since 0.1.0
  NonexistentEntityError = Class.new(Error)

  # @see QuantumCore::Container::DependencyCompatability::General
  # @see QuantumCore::Container::DependencyCompatability::Definition
  # @see QuantumCore::Container::DependencyCompatability::Registry
  #
  # @api public
  # @since 0.1.0
  DependencyOverNamespaceOverlapError = Class.new(Error)

  # @see QuantumCore::Container::DependencyCompatability::General
  # @see QuantumCore::Container::DependencyCompatability::Definition
  # @see QuantumCore::Container::DependencyCompatability::Registry
  #
  # @api public
  # @since 0.1.0
  NamespaceOverDependencyOverlapError = Class.new(Error)
end
