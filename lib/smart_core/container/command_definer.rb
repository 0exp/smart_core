# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container
  class CommandDefiner
    # @param container_klass [Class<SmartCore::Container>]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def initialize(container_klass)
      @container_klass = container_klass
      @access_lock = Mutex.new
    end

    # @param namespace_name [String, Symbol]
    # @param dependency_definitions [Block]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def append_namespace(namespace_name, &dependency_definitions)
      thread_safe do
        command = SmartCore::Container::Namespace.new(
          namespace_name,
          dependency_definitions
        )
      end
    end

    # @param dependency_name [String, Symbol]
    # @param options [Hash<Symbol,Any>]
    # @param dependency_definition [Block]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def append_register(dependency_name, **options, &dependency_definition)
      thread_safe do
        command = SmartCore::Container::Register.new(
          dependency_name,
          dependency_definition,
          options
        )
      end
    end

    private

    # @return [Class<SmartCore::Container>]
    #
    # @api private
    # @since 0.5.0
    attr_reader :container_klass

    # @param block [Block]
    # @return [Any]
    #
    # @api private
    # @since 0.5.0
    def thread_safe(&block)
      @access_lock.synchronize(&block)
    end

    # @param namespace_name [String, Symbol]
    # @return [void]
    #
    # @see [SmartCore::Container::DependencyCompatability::CommandSetChecker]
    #
    # @api private
    # @since 0.5.0
    def prevent_incompatabilities!(namespace_name)
      DependencyCompatability::CommandSet
    end
  end
end
