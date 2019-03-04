# frozen_string_literal: true

# @api private
# @since 0.5.0
module SmartCore::Container::Registry::Compatability
  class << self
    # @parma dependency_name [String, Symbol, Any]
    # @return [Symbol]
    #
    # @api private
    # @since 0.5.0
    def indifferently_accessable_dependency_name(dependency_name)
      prevent_dependency_name_incompatabilities!(dependency_name)
      dependency_name.to_sym
    end

    # @parma dependency [String, Symbol, Any]
    # @return [String]
    #
    # @api private
    # @since 0.5.0
    def indifferently_accessable_dependency(dependency)
      prevent_dependency_incompatabilites!(dependency)
      SmartCore::Container::Registry::Dependency.new(dependency)
    end

    private

    # @param dependency_name [String, Symbol, Any]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def prevent_dependency_name_incompatabilities!(dependency_name)
      raise(
        SmartCore::Container::ArgumentError,
        'Dependency name should be a symbol or a string!'
      ) unless dependency_name.is_a?(Symbol) || dependency_name.is_a?(String)
    end

    # @param dependency [#call]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def prevent_dependency_incompatabilites!(dependency)
      raise(
        SmartCore::Container::ArgumentError,
        'Dependency object should respond to #call method'
      ) unless dependency.respond_to?(:call)
    end
  end
end
