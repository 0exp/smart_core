# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Validator::AttributeSet
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
    @attributes = {}
    @access_lock = Mutex.new
  end

  # @param attribute [Symbiont::Validator::Attribute]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_attribute(attribute)
    thread_safe { attributes[attribute.name] = attribute }
  end
  alias_method :<<, :add_attribute

  # @param attribute_set [SmartCore::Validator::AttributeSet]
  # @return [void]
  #
  # @api private
  # @sinec 0.1.0
  def concat(attribute_set)
    thread_safe { attributes.merge!(attribute_set.attributes) }
  end

  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each(&block)
    thread_safe { block_given? ? attributes.each_value(&block) : attributes.each_value }
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
