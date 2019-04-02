# frozen_string_literal: true

module SmartCore::Container::Commands
  # @api private
  # @since 0.5.0
  class Namespace < Base
    # @return [String, Symbol]
    #
    # @api private
    # @since 0.5.0
    attr_reader :namespace_name

    # @param namespace_name [String, Symbol]
    # @param dependency_definitions [Proc]
    # @return [void]
    #
    # @see [SmartCore::Container::KeyGuard]
    #
    # @api private
    # @since 0.5.0
    def initialize(namespace_name, dependency_definitions)
      SmartCore::Container::KeyGuard.prevent_incomparabilities!(namespace_name)

      @namespace_name = namespace_name.to_s
      @dependency_definitions = dependency_definitions
    end

    # @param registry [SmartCore::Container::Registry]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def call(registry)
      registry.namespace(namespace_name, &dependency_definitions)
    end

    # @return [SmartCore::Container::Commands::Namespace]
    #
    # @api private
    # @since 0.5.0
    def dup
      self.class.new(namespace_name, dependency_definitions)
    end

    private

    # @return [Proc]
    #
    # @api private
    # @since 0.5.0
    attr_reader :dependency_definitions
  end
end
