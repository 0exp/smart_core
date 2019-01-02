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
      prevent_incorrect_attribute!(attribute_name)
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
    thread_safe { attributes.merge(attribute_set.attributes) }
  end

  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each(&block)
    thread_safe { block_given? ? attributes.each(&block) : attributes }
  end

  private

  # @return [void]
  #
  # @raise [Symbiont::Validator::IncorrectAttributeNameError]
  #
  # @api private
  # @since 0.1.0
  def prevent_incorrect_attribute!(attribute_name)
    unless attribute_name.is_a?(Symbol) || attribute_name.is_a?(String)
      raise(
        SmartCore::Validator::IncorrectAttributeNameError,
        'Attribute name should be a symbol or a string'
      )
    end
  end

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe
    @access_lock.synchronize { yield if block_given? }
  end
end
