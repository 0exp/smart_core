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
    # @param dependency_definitions [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def append_namespace(namespace_name, dependency_definitions)
      thread_safe do
        command = build_namespace_command(namespace_name, dependency_definitions)
        prevent_dependency_overlap(command)
        append_command(command)
      end
    end

    # @param dependency_name [String, Symbol]
    # @param dependency_definition [Proc]
    # @param options [Hash<Symbol,Any>]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def append_register(dependency_name, dependency_definition, options)
      thread_safe do
        command = build_register_command(dependency_name, dependency_definition, options)
        prevent_namespace_overlap(command)
        append_command(command)
      end
    end

    private

    # @return [Class<SmartCore::Container>]
    #
    # @api private
    # @since 0.5.0
    attr_reader :container_klass

    def prevent_dependency_overlap(namespace_name)
    end

    def prevent_command_overlap(dependency_name)
    end

    # @param namespace_name [String]
    # @param dependency_definitions [Proc]
    # @return [SmartCore::Container::Commands::Namespace]
    #
    # @api private
    # @since 0.5.0
    def build_namespace_command(namespace_name, dependency_definitions)
      SmartCore::Container::Commands::Namespace.new(
        namespace_name, dependency_definitions
      )
    end

    # @param dependency_name [String]
    # @param dependency_definition [Proc]
    # @param option [Hash<Symbol,Any>]
    # @return [SmartCore::Container::Commands::Register]
    #
    def build_register_command(dependency_name, dependency_definition, options)
      SmartCore::Container::Commands::Register.new(
        dependency_name, dependency_definition, **options
      )
    end

    # @param command [SmartCore::Container::Commands::Base]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def append_command(command)
      container_klass.__commands__.add_command(command)
    end

    # @param block [Block]
    # @return [Any]
    #
    # @api private
    # @since 0.5.0
    def thread_safe(&block)
      @access_lock.synchronize(&block)
    end
  end
end
