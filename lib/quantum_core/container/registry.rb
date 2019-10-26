# frozen_string_literal: true

# @api private
# @since 0.1.0
class QuantumCore::Container::Registry
  # @since 0.1.0
  include Enumerable

  # @return [Hash<Symbol,QuantumCore::Container::Entity>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :registry

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @registry = {}
    @access_lock = QuantumCore::Container::ArbitaryLock.new
  end

  # @param entity_path [String, Symbol]
  # @return [QuantumCore::Container::Entity]
  #
  # @api private
  # @since 0.1.0
  def resolve(entity_path)
    thread_safe { fetch_entity(entity_path) }
  end

  # @param name [String, Symbol]
  # @param dependency_definition [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def register_dependency(name, &dependency_definition)
    thread_safe { add_dependency(name, dependency_definition) }
  end

  # @param name [String, Symbol]
  # @param dependencies_definition [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def register_namespace(name, &dependencies_definition)
    thread_safe { add_namespace(name, dependencies_definition) }
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def freeze!
    thread_safe { freeze_state }
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def frozen?
    thread_safe { state_frozen? }
  end

  # @param block [Block]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each(&block)
    thread_safe { block_given? ? registry.each_value(&block) : registry.each_value }
  end

  private

  # @return [Mutex]
  #
  # @api private
  # @since 0.1.0
  attr_reader :lock

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def state_frozen?
    registry.frozen?
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def freeze_state
    registry.freeze
  end

  # @paramm entity_path [String, Symbol]
  # @return [QuantumCore::Container::Entity]
  #
  # @api private
  # @since 0.1.0
  def fetch_entity(entity_path)
    dependency_name = indifferently_accessable_name(entity_path)
    registry.fetch(dependency_name)
  rescue KeyError
    raise(
      QuantumCore::Container::NonexistentEntityError,
      "Entity with '#{dependency_name}' name does not exist!"
    )
  end

  # @param dependency_name [String, Symbol]
  # @param dependency_definition [Proc]
  # @return [void]
  #
  # @raise [QuantumCore::Container::DependencyOverNamespaceOverlapError]
  #
  # @api private
  # @since 0.1.0
  def add_dependency(dependency_name, dependency_definition)
    if state_frozen?
      raise(QuantumCore::Container::FrozenRegistryError, 'Can not modify frozen registry!')
    end
    dependency_name = indifferently_accessable_name(dependency_name)
    prevent_namespace_overlap!(dependency_name)

    dependency_entity = QuantumCore::Container::Entities::DependencyBuilder.build(
      dependency_name, dependency_definition
    )

    registry[dependency_name] = dependency_entity
  end

  # @param namespace_name [String, Symbol]
  # @param dependencies_definition [Proc]
  # @return [void]
  #
  # @raise [QuantumCore::Container::NamespaceOverDependencyOverlapError]
  #
  # @api private
  # @since 0.1.0
  def add_namespace(namespace_name, dependencies_definition)
    if state_frozen?
      raise(QuantumCore::Container::FrozenRegistryError, 'Can not modify frozen registry!')
    end
    namespace_name = indifferently_accessable_name(namespace_name)
    prevent_dependency_overlap!(namespace_name)

    # rubocop:disable Layout/RescueEnsureAlignment
    namespace_entity = begin
      fetch_entity(namespace_name)
    rescue QuantumCore::Container::NonexistentEntityError
      registry[namespace_name] = QuantumCore::Container::Entities::NamespaceBuilder.build(
        namespace_name
      )
    end
    # rubocop:enable Layout/RescueEnsureAlignment

    namespace_entity.append_definitions(dependencies_definition)
  end

  # @param name [String, Symbol]
  # @return [void]
  #
  # @see [QuantumCore::Container::KeyGuard]
  #
  # @api private
  # @since 0.1.0
  def indifferently_accessable_name(name)
    QuantumCore::Container::KeyGuard.indifferently_accessable_key(name)
  end

  # @param dependency_name [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def prevent_namespace_overlap!(dependency_name)
    QuantumCore::Container::DependencyCompatability::Registry.prevent_namespace_overlap!(
      self, dependency_name
    )
  end

  # @param namespace_name [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def prevent_dependency_overlap!(namespace_name)
    QuantumCore::Container::DependencyCompatability::Registry.prevent_dependency_overlap!(
      self, namespace_name
    )
  end

  # @param block [Proc]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @access_lock.thread_safe(&block)
  end
end
