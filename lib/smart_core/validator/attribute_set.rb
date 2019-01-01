# frozen_string_literal: true

class SmartCore::Validator
  # @api private
  # @since 0.1.0
  class AttributeSet
    # @since 0.1.0
    include Enumerable

    # @return [Set]
    #
    # @api private
    # @since 0.1.0
    attr_reader :attributes

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize
      @attributes = Set.new
      @access_lock = Mutex.new
    end

    # @param attribute_name [String, Symbol]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def add_attribute(attribute_name)
      thread_safe do
        unless attribute_name.is_a?(Symbol) || attribute_name.is_a?(String)
          raise IncorrectAttributeNameError
        end

        attributes << attribute_name
      end
    end
    alias_method :<<, :add_attribute

    # @param attribute_set [SmartCore::Validator::AttributeSet]
    # @return [void]
    #
    # @api private
    # @sinec 0.1.0
    def concat(attribute_set)
      attributes.merge(attribute_set.attributes)
    end

    # @return [Enumerable]
    #
    # @api private
    # @since 0.1.0
    def each(&block)
      thread_safe do
        block_given? ? attributes.each(&block) : attributes
      end
    end

    private

    # @return [Any]
    #
    # @api private
    # @since 0.1.0
    def thread_safe
      @access_lock.synchronize { yield if block_given? }
    end
  end
end
