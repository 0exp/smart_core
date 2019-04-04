# frozen_string_literal: true

class SmartCore::Container
  # @api private
  # @since 0.5.0
  class Registry
    # @since 0.5.0
    include Enumerable

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

    # @param block [Block]
    # @return [Enumerable]
    #
    # @api private
    # @since 0.5.0
    def each(&block)
      thread_safe { block_given? ? registry.each_value(&block) : registry.each_value }
    end

    # @return [Hash<Symbol,Any>]
    #
    # @api private
    # @since 0.5.0
    def to_h
      # TODO: implement :)
    end

    private

    # @return [Mutex]
    #
    # @api private
    # @since 0.5.0
    attr_reader :access_lock

    # @return [Hash<Symbol,SmartCore::Container::Entity>]
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
    # @return [SmartCore::Container::Namespace, SmartCore::Container::Dependency]
    #
    # @api private
    # @since 0.5.0
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
      dependency_name = indifferently_accessable_name(dependency_name)
      prevent_namespace_overlap!(dependency_name)
      dependency = DependencyBuilder.build(dependency_name, dependency_definition, **options)

      registry[dependency_name] = dependency
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
      namespace_name = indifferently_accessable_name(namespace_name)
      prevent_dependency_overlap!(namespace_name)

      namespace = begin
        registry.fetch(namespace_name)
      rescue KeyError
        registry[namespace_name] = SmartCore::Container::Namespace.new(namespace_name)
      end

      namespace.append_definitions(dependency_definitions)
    end

    # @param name [String, Symbol]
    # @return [void]
    #
    # @see [SmartCore::Container::KeyGuard]
    #
    # @api private
    # @since 0.5.0
    def indifferently_accessable_name(name)
      SmartCore::Container::KeyGuard.indifferently_accessable_key(name)
    end

    # @param dependency_name [String]
    # @retrun [void]
    #
    # @api private
    # @since 0.5.0
    def prevent_namespace_overlap!(dependency_name)
      DependencyCompatability::Registry.prevent_namespace_overlap!(self, dependency_name)
    end

    # @param namespace_name [String]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def prevent_dependency_overlap!(namespace_name)
      DependencyCompatability::Registry.prevent_dependency_overlap!(self, namespace_name)
    end

    # @param block [Proc]
    # @return [Any]
    #
    # @api private
    # @since 0.5.0
    def thread_safe(&block)
      # NOTE:
      #   #owned => yield is a thread safe in our siuation cuz this logic can be invoked
      #   here from the already owned access lock only
      @access_lock.owned? ? yield : @access_lock.synchronize(&block)
    end
  end
end
