# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Initializer::ExtensionSet
  # @since 0.5.0
  include Enumerable

  # @return [Array<SmartCore::Initializer::InitializationExtension>]
  #
  # @api private
  # @since 0.5.0
  attr_reader :extensions

  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize
    @extensions = []
    @access_lock = Mutex.new
  end

  # @param extension [SmartCore::Initializer::InitializationExtension]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def add_extension(extension)
    thread_safe { extensions << extension }
  end
  alias_method :<<, :add_extension

  # @return [SmartCore::Initializer::ExtensionSet]
  #
  # @api private
  # @since 0.5.0
  def dup
    thread_safe do
      self.class.new.tap do |duplicate|
        extensions.each do |extension|
          duplicate.add_extension(extension.dup)
        end
      end
    end
  end

  # @return [Enumerable]
  #
  # @api private
  # @since 0.5.0
  def each(&block)
    thread_safe { block_given? ? extensions.each(&block) : extensions.each }
  end

  # @param extension_set [SmartCore::Initializer::ExtensionSet]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def concat(extension_set)
    thread_safe { extensions.concat(extension_set.dup.extensions) }
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
