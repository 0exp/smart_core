# frozen_string_literal: true

# @api private
# @since 0.5.0
module SmartCore::Container::DefinitionDSL
  class << self
    # @param base_klass [Class<SmartCore::Container>]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def included(base_klass)
      base_klass.instance_variable_set(:@__commands__, SmartCore::Container::CommandSet.new)
      base_klass.singleton_class.send(:attr_reader, :__commands__)
      base_klass.extend(ClassMethods)
      base_klass.singleton_class.prepend(ClassInheritance)
    end
  end

  # @api private
  # @since 0.5.0
  module ClassInheritance
    # @param child_klass [Class<SmartCore::Container>]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def inherited(child_klass)
      child_klass.instance_variable_set(:@__commands__, SmartCore::Container::CommandSet.new)
      child_klass.__commands__.concat(__commands__)
      child_klass.singleton_class.prepend(ClassInheritance)
      super
    end
  end

  # @api private
  # @since 0.5.0
  module ClassMethods
    # @param namespace_name [String, Symbol]
    # @param dependency_definitions [Block]
    # @return [void]
    #
    # @api public
    # @since 0.5.0
    def namespace(namespace_name, &dependency_definitions)
      __commands__ << SmartCore::Container::Commands::Namespace.new(
        namespace_name, dependency_definitions
      )
    end

    # @param dependency_name [String, Symbol]
    # @param options [Hash<Symbol,Any>]
    # @param dependency_definition [Proc]
    # @return [void]
    #
    # @todo option list
    #
    # @api public
    # @since 0.5.0
    def register(dependency_name, **options, &dependency_definition)
      __commands__ << SmartCore::Container::Commands::Register.new(
        dependency_name, dependency_definition, **options
      )
    end
  end
end
