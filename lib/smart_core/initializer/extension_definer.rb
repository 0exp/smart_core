# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Initializer::ExtensionDefiner
  # @param processed_klass [Class]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize(processed_klass)
    @processed_klass = processed_klass
    @definition_lock = Mutex.new
  end

  # @param raw_extension [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def append_extension(raw_extension)
    thread_safe do
      extension = build_extension(raw_extension)
      extend_initialization_flow(extension)
    end
  end

  private

  # @return [Class]
  #
  # @api private
  # @since 0.5.0
  attr_reader :processed_klass

  # @param raw_extension [Proc]
  # @return [SmartCore::Initializar::Extension]
  #
  # @api private
  # @since 0.5.0
  def build_extension(raw_extension)
    SmartCore::Initializer::Extension.new(raw_extension)
  end

  # @param extension [SmartCore::Initializer::Extension]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def extend_initialization_flow(extension)
    processed_klass.__initialization_extensions__ << extension
  end

  # @param block [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def thread_safe(&block)
    @definition_lock.synchronize(&block)
  end
end
