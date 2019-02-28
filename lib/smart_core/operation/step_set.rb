# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Operation::StepSet
  # @since 0.5.0
  include Enumerable

  # @return [Array<SmartCore:::Operation::Step>]
  #
  # @api private
  # @since 0.5.0
  attr_reader :steps

  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize
    @steps = []
    @access_lock = Mutex.new
  end

  # @param step [SmartCore::Operation::Step]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def add_step(step)
    thread_safe { steps << step }
  end
  alias_method :<<, :add_step

  # @param step_set [SmartCore::Operation::Step]
  # @return [void]
  #
  # @api private
  # @sinec 0.5.0
  def concat(step_set)
    thread_safe { steps.concat(step_set.dup.steps) }
  end

  # @retun [SmartCore::Operation::StepSet]
  #
  # @api private
  # @since 0.5.0
  def dup
    thread_safe do
      self.class.new.tap do |duplicate|
        steps.each { |step| duplicate.add_step(step.dup) }
      end
    end
  end

  # @return [Enumerable]
  #
  # @api private
  # @since 0.5.0
  def each(&block)
    thread_safe { block_given? ? steps.each(&block) : steps.each }
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
