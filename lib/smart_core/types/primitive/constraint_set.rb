# frozen_string_literal: true

# @api private
# @since 0.9.0
class SmartCore::Types::Primitive::ConstraintSet
  # @api private
  # @since 0.9.0
  def initialize
    @constraints = []
    @lock = SmartCore::Types::Lock.new
  end

  # @param constraint [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.9.0
  def append_constraint(constraint)
    @lock.thread_safe do
    end
  end
end
