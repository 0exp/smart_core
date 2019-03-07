# frozen_string_literal: true

# @api public
# @since 0.5.0
module SmartCore::Container::Mixin
  class << self
    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def included(base_klass) # rubocop:disable Metrics/LineLength
      base_klass.instance_variable_set(:@__smart_core_container_access_lock__, Mutex.new)
      base_klass.instance_variable_set(:@__smart_core_container_definition_lock__, Mutex.new)
      base_klass.instance_variable_set(:@__smart_core_container_klass__, Class.new(SmartCore::Container))
      base_klass.instance_variable_set(:@__smart_core_container__, nil)

      base_klass.extend(ClassMethods)
      base_klass.include(InstanceMethods)
      base_klass.singleton_class.prepend(ClassInheritance)
    end
  end

  # @api private
  # @since 0.5.0
  module ClassInheritance
    # @param child_klass [CLass]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def inherited(child_klass) # rubocop:disable Metrics/LineLength
      inherited_container_klass = Class.new(@__smart_core_container_klass__)

      child_klass.instance_variable_set(:@__smart_core_container_access_lock__, Mutex.new)
      child_klass.instance_variable_set(:@__smart_core_container_definition_lock__, Mutex.new)
      child_klass.instance_variable_set(:@__smart_core_container_klass__, inherited_container_klass)
      child_klass.instance_variable_set(:@__smart_core_container__, nil)

      super
    end
  end

  # @api private
  # @since 0.5.0
  module ClassMethods
    # @param block [Proc]
    # @return [void]
    #
    # @api public
    # @since 0.5.0
    def define_dependencies(&block)
      @__smart_core_container_definition_lock__.synchronize do
        @__smart_core_container_klass__.instance_eval(&block) if block_given?
      end
    end

    # @return [SmartCore::Container]
    #
    # @api public
    # @since 0.5.0
    def container
      @__smart_core_container_definition_lock__.synchronize do
        @__smart_core_container__ ||= @__smart_core_container_klass__.new
      end
    end
  end

  # @api private
  # @since 0.5.0
  module InstanceMethods
    # @return [SmartCore::Container]
    #
    # @api public
    # @since 0.5.0
    def container
      self.class.container
    end
  end
end
