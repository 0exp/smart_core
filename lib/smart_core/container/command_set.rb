# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container::CommandSet
  # @since 0.5.0
  include Enumerable

  # @return [Array<SmartCore::Container::Commands::Base>]
  #
  # @api private
  # @since 0.5.0
  attr_reader :commands

  # @api private
  # @since 0.5.0
  def initialize
    @commands = []
    @access_lock = Mutex.new
  end

  # @param command [SmartCore::Container::Commands::Base]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def add_command(command)
    thread_safe { commands << command }
  end
  alias_method :<<, :add_command

  # @yield [SmartCore::Container::Commands::Base]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.5.0
  def each(&block)
    thread_safe { block_given? ? commands.each(&block) : commands.each }
  end

  # @param command_set [SmartCore::Container::CommandSet]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def concat(command_set)
    thread_safe { commands.concat(command_set.commands) }
  end

  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def clear
    thread_safe { commands.clear }
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
