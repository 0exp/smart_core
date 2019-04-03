# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container::Namespace < SmartCore::Container::Entity
  # @param external_name [String]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize(external_name)
    @container = Class.new(SmartCore::Container)
    @container_instance = nil
    @access_lock = Mutex.new
    super(external_name)
  end

  # @param dependency_definitions [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def append_definitions(dependency_definitions)
    container.instance_eval(&dependency_definitions)
  end

  # @return [SmartCore::Container]
  #
  # @api private
  # @since 0.5.0
  def call
    thread_safe { @container_instance ||= container.new }
  end

  private

  # @return [Class<SmartCore::Container>]
  #
  # @api private
  # @since 0.5.0
  attr_reader :container

  # @param block [Proc]
  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  def thread_safe(&block)
    @access_lock.synchronize(&block)
  end
end
