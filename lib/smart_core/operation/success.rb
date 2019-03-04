# frozen_string_literal: true

# @api public
# @since 0.2.0
class SmartCore::Operation::Success < SmartCore::Operation::Result
  # @param result_options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @api public
  # @since 0.2.0
  def initialize(**result_options)
    __prevent_method_overlapping__(result_options)
    super(**result_options) # NOTE: initialize result object
    __define_virtual_result_data_accessors__(result_options)
  end

  # @yield [nil]
  # @return [Boolean]
  #
  # @api public
  # @since 0.2.0
  def success?
    true.tap { yield(self) if block_given? }
  end

  # Support for operations like `result.success? { |**result| ...result-as-a-hash... }`
  #
  # @return [Hash]
  #
  # @api public
  # @since 0.5.0
  def to_h
    __result_options__.dup
  end
  alias_method :to_hash, :to_h

  private

  # @param result_options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @raise [SmartCore::Operation::IncompatibleResultKeyError]
  # @raise [SmartCore::Operation::ResultMethodIntersectionError]
  #
  # @api private
  # @since 0.2.0
  def __prevent_method_overlapping__(result_options)
    overlappings = result_options.each_key.each_with_object([]) do |key, overlap|
      overlap << key if self.class.__core_methods__.include?(key)
    end

    raise(
      SmartCore::Operation::ResultMethodIntersectionError,
      "Result keys can not overlap core methods " \
      "(overlapping keys: #{overlappings.join(', ')})."
    ) if overlappings.any?
  end

  # @param result_options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def __define_virtual_result_data_accessors__(result_options)
    result_options.each_key do |result_attribute_name|
      define_singleton_method(result_attribute_name) do
        __result_options__[result_attribute_name]
      end
    end
  end

  core_methods = (
    instance_methods(false) | private_instance_methods(false) |
    superclass.instance_methods(false) | superclass.private_instance_methods(false)
  ).freeze

  # @return [Array<Symbol>]
  #
  # @api private
  # @since 0.2.0
  define_singleton_method(:__core_methods__) { core_methods }
end
