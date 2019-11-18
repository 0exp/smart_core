# frozen_string_literal: true

# @api private
# @sicne 0.9.0
class SmartCore::Types::Primitive
  # @return [void]
  #
  # @api private
  # @since 0.9.0
  def initialize
    @checker = nil
    @constraints = []
    @lock = SmartCore::Types::Lock.new
  end

  # @param checker [Block]
  # @return [void]
  #
  # @api private
  # @since 0.9.0
  def define_checker(&checker)
    @lock.thread_safe { @checker = checker }
  end

  # @param option [String, Symbol]
  # @param checker [Block]
  # @return [void]
  #
  # @api private
  # @since 0.9.0
  def add_constraint(option, &checker)
    @lock.thread_safe { }
  end
end
