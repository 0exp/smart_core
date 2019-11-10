# frozen_string_literal: true

# @api public
# @since 0.7.0
module SmartCore::Container::Mixin
  class << self
    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.7.0
    def included(base_klass)
      # rubocop:disable Metrics/LineLength
      base_klass.instance_variable_set(:@__smart_core_container_access_lock__, SmartCore::Container::ArbitaryLock.new)
      base_klass.instance_variable_set(:@__smart_core_container_klass__, Class.new(SmartCore::Container))
      base_klass.instance_variable_set(:@__smart_core_container__, nil)
      # rubocop:enable Metrics/LineLength

      base_klass.extend(ClassMethods)
      base_klass.include(InstanceMethods)
      base_klass.singleton_class.prepend(ClassInheritance)
    end
  end

  # @api private
  # @since 0.7.0
  module ClassInheritance
    # @param child_klass [CLass]
    # @return [void]
    #
    # @api private
    # @since 0.7.0
    def inherited(child_klass)
      inherited_container_klass = Class.new(@__smart_core_container_klass__)

      # rubocop:disable Metrics/LineLength
      child_klass.instance_variable_set(:@__smart_core_container_access_lock__, SmartCore::Container::ArbitaryLock.new)
      child_klass.instance_variable_set(:@__smart_core_container_klass__, inherited_container_klass)
      child_klass.instance_variable_set(:@__smart_core_container__, nil)
      # rubocop:disable Metrics/LineLength

      super
    end
  end

  # @api private
  # @since 0.7.0
  module ClassMethods
    # @param freeze_state [Boolean]
    # @param block [Proc]
    # @return [void]
    #
    # @api public
    # @since 0.7.0
    def dependencies(freeze_state: false, &block)
      @__smart_core_container_access_lock__.thread_safe do
        @__smart_core_container_klass__.instance_eval(&block) if block_given?
        @__smart_core_container_klass__.instance_eval { freeze_state! } if freeze_state
      end
    end

    # @return [SmartCore::Container]
    #
    # @api public
    # @since 0.7.0
    def container
      @__smart_core_container_access_lock__.thread_safe do
        @__smart_core_container__ ||= @__smart_core_container_klass__.new
      end
    end
  end

  # @api private
  # @since 0.7.0
  module InstanceMethods
    # @return [SmartCore::Container]
    #
    # @api public
    # @since 0.7.0
    def container
      self.class.container
    end
  end
end
