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
    result_object_methods = methods # TODO: list protected instance methods manually

    # NOTE: prevent core result object method overlap
    result_options.each_key do |key|
      raise(
        ResultMethodIntersectionError,
        'Result keys can not overlap core result object methods.'
      ) if result_object_methods.include?(key)
    end

    super(**result_options) # NOTE: initialize result object

    # NOTE: define virtual attibute accessors for the result data
    result_options.each_key do |result_attribute_name|
      define_singleton_method(result_attribute_name) do
        __result_options__[result_attribute_name]
      end
    end
  end

  # @yield [nil]
  # @return [Boolean]
  #
  # @api public
  # @since 0.2.0
  def success?
    true.tap { yield(self) if block_given? }
  end
end
