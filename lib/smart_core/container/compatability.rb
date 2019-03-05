# frozen_string_literal: true

# @api private
# @since 0.5.0
module SmartCore::Container::Compatability
  class << self
    # @param key [String, Symbol, Any]
    # @return [Symbol]
    #
    # @api private
    # @since 0.5.0
    def indifferently_accessable_key(key)
      prevent_key_incompatabilities!(key)
      key.to_sym
    end
    # @since 0.5.0
    alias_method :indifferently_accessable_dependency_name, :indifferently_accessable_key
    # @since 0.5.0
    alias_method :indifferently_accessable_namespace_name,  :indifferently_accessable_key

    # @param dependency [String, Symbol, Any]
    # @return [String]
    #
    # @api private
    # @since 0.5.0
    def indifferently_accessable_dependency(dependency)
      prevent_dependency_incompatabilites!(dependency)
      SmartCore::Container::Dependency.new(dependency)
    end

    # @param key [String, Symbol, Any]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def prevent_key_incompatabilities!(key)
      raise(
        SmartCore::Container::ArgumentError,
        'Dependency/Namespace name should be a symbol or a string!'
      ) unless key.is_a?(Symbol) || key.is_a?(String)
    end
    # @since 0.5.0
    alias_method :prevent_dependency_name_incompatabilities!, :prevent_key_incompatabilities!
    # @since 0.5.0
    alias_method :prevent_namespace_name_incompatabilities!,  :prevent_key_incompatabilities!

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
