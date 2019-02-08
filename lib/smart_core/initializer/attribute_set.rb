# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Initializer::AttributeSet
  # @since 0.5.0
  include Enumerable

  # @return [Hash<Symbol, SmartCore::Initializer::Attribute>]
  #
  # @api private
  # @since 0.5.0
  attr_reader :attributes

  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize
    @attributes = {}
    @access_lock = Mutex.new
  end

  # @param attribute [SmartCore::Initializer::Attribute]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def add_attribute(attribute)
    thread_safe { attributes[attribute.name] = attribute }
  end
  alias_method :<<, :add_attribute

  # @param attribute_set [SmartCore::Initializer::AttributeSet]
  # @return [void]
  #
  # @api private
  # @sinec 0.5.0
  def concat(attribute_set)
    thread_safe { attributes.merge!(attribute_set.dup.attributes) }
  end

  # @param attribute [SmartCore::Initializer::Attribute]
  # @return [Boolean]
  #
  # @api private
  # @since 0.5.0
  def conflicts_with?(attribute)
    thread_safe { attributes.key?(attribute.name) }
  end

  # @return [SmartCore::Initializer::AttributeSet]
  #
  # @api private
  # @since 0.5.0
  def dup
    thread_safe do
      self.class.new.tap do |duplicate|
        attributes.each_value do |attribute|
          duplicate.add_attribute(attribute.dup)
        end
      end
    end
  end

  # @return [Integer]
  #
  # @api private
  # @since 0.5.0
  def size
    thread_safe { attributes.size }
  end

  # @return [Enumerable]
  #
  # @api private
  # @since 0.5.0
  def each(&block)
    thread_safe { block_given? ? attributes.each_value(&block) : attributes.each_value }
  end

  private

  # @param block [Proc]
  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  def thread_safe(&block)
    @access_lock.synchronize(&block)
  end
end
