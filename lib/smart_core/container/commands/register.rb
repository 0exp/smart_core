# frozen_string_literal: true

module SmartCore::Container::Commands
  # @api private
  # @since 0.5.0
  class Register < Base
    # @param dependency_name [String, Symbol]
    # @param dependency_definition [Proc]
    # @return [void]
    #
    # @see [SmartCore::Container::KeyGuard]
    #
    # @api private
    # @since 0.5.0
    def initialize(dependency_name, dependency_definition)
      SmartCore::Container::KeyGuard.prevent_incomparabilities!(dependency_name)

      @dependency_name = dependency_name.to_s
      @dependency_definition = dependency_definition
    end

    # @param registry [SmartCore::Container::Registry]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def call(registry)
      registry.register(dependency_name, &dependency_definition)
    end

    # @return [SmartCore::Container::Commands::Register]
    #
    # @api private
    # @since 0.5.0
    def dup
      self.class.new(dependency_name, dependency_definition)
    end

    private

    # @return [String, Symbol]
    #
    # @api private
    # @since 0.5.0
    attr_reader :dependency_name

    # @return [Proc]
    #
    # @api private
    # @since 0.5.0
    attr_reader :dependency_definition
  end
end
