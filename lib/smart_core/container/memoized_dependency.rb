# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container::MemoizedDependency < SmartCore::Container::Dependency
  # @param dependency_definition [Proc]
  # @param options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @todo option list
  # @see [SmartCore::Container::Dependency]
  #
  # @api private
  # @since 0.5.0
  def initialize(dependency_definition, **options)
    @memoized_call = nil
    super
  end

  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  def call
    thread_safe { @memoized_call ||= dependency_definition.call }
  end
end
