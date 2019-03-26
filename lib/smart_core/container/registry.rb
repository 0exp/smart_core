# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container::Registry
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize
    @access_lock = Mutex.new
    @registry = {}
  end

  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def freeze
    thread_safe { freeze_state }
  end

  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def frozen?
    thread_safe { state_frozen? }
  end

  # @param dependency_path [String, Symbol]
  # @return [SmartCore::Container::Namespace, SmartCore::Container::Dependnecy]
  #
  # @api private
  # @since 0.5.0
  def resolve(dependency_path)
    thread_safe { fetch_dependency(dependency_path) }
  end

  # @param name [String, Symbol]
  # @param options [Hash<Symbol,Any>]
  # @param dependency_definition [Block]
  # @return [void]
  #
  # @todo option list
  #
  # @api private
  # @since 0.5.0
  def register(name, **options, &dependency_definition)
    thread_safe do
      raise(
        SmartCore::Container::FrozenRegistryError,
        'Can not modify frozen registry'
      ) if state_frozen?

      append_dependency(name, dependency_definition, **options)
    end
  end

  # @param name [String, Symbol]
  # @param dependency_definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def namespace(name, &dependency_definitions)
    thread_safe do
      raise(
        SmartCore::Container::FrozenRegistryError,
        'Can not modify frozen registry'
      ) if state_frozen?

      append_namespace(name, dependency_definitions)
    end
  end

  private

  # @return [Mutex]
  #
  # @api private
  # @since 0.5.0
  attr_reader :access_lock

  # @return [Hash<Symbol,SmartCore::Container::Dependency|SmartCore::Container::Namespace>]
  #
  # @api private
  # @since 0.5.0
  attr_reader :registry

  # @return [Boolean]
  #
  # @api private
  # @since 0.5.0
  def state_frozen?
    registry.frozen?
  end

  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def freeze_state
    registry.freeze
  end

  # @paramm dependency_path [String, Symbol]
  # @return [SmartCore::Container::Namespace,]
  def fetch_dependency(dependency_path)
    # TODO: rabbit style dependnecy path
    name = indifferently_accessable_name(dependency_path)
    registry.fetch(name)
  rescue KeyError
    raise(
      SmartCore::Container::UnexistentDependencyError,
      "Dependencny with '#{name}' name does not exist!"
    )
  end

  # @param dependency_name [String, Symbol]
  # @param dependency_definition [Proc]
  # @param options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @todo option list
  # @raise [SmartCore::Container::NamespaceOverlapError]
  #
  # @api private
  # @since 0.5.0
  def append_dependency(dependency_name, dependency_definition, **options)
    name = indifferently_accessable_name(dependency_name)

    raise(
      SmartCore::Container::NamespaceOverlapError,
      "Trying to overlap already registered :#{name} namespace with :#{name} dependency!"
    ) if has_namespace?(name)

    dependency = SmartCore::Container::DependencyBuilder.build(dependency_definition, **options)
    registry[name] = dependency
  end

  # @param namespace_name [String, Symbol]
  # @param dependency_definitions [Proc]
  # @return [void]
  #
  # @raise [SmartCore::Container::DependencyOverlapError]
  #
  # @api private
  # @since 0.5.0
  def append_namespace(namespace_name, dependency_definitions)
    name = indifferently_accessable_name(namespace_name)

    raise(
      SmartCore::Container::DependencyOverlapError,
      "Trying to overlap already registered :#{name} dependency with :#{name} namespace!"
    ) if has_dependency?(name)

    if has_namespace?(name)
      registry.fetch(name).tap do |namespace|
        namespace.append_definitions(dependency_definitions)
      end
    else
      SmartCore::Container::Namespace.new.tap do |namespace|
        namespace.append_definitions(dependency_definitions)
        registry[name] = namespace
      end
    end
  end

  # @param name [String, Symbol]
  # @return [Boolean]
  #
  # @api private
  # @since 0.5.0
  def has_namespace?(name)
    name = indifferently_accessable_name(name) # TODO: mb this line is totally useless. m?
    registry.key?(name) && registry.fetch(name).is_a?(SmartCore::Container::Namespace)
  end

  # @param name [String, Symbol]
  # @return [Boolean]
  #
  # @api private
  # @since 0.5.0
  def has_dependency?(name)
    name = indifferently_accessable_name(name) # TODO: mb this line is totally useless. m?
    registry.key?(name) && registry.fetch(name).is_a?(SmartCore::Container::Dependency)
  end

  # @param name [String, Symbol]
  # @return [void]
  #
  # @see [SmartCore::Container::KeyGuard]
  #
  # @api private
  # @since 0.5.0
  def indifferently_accessable_name(name)
    SmartCore::Container::KeyGuard.prevent_incomparabilities!(name)
    name.to_s
  end

  # @param block [Proc]
  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  def thread_safe(&block)
    @access_lock.synchronize(&block)
  end
end
