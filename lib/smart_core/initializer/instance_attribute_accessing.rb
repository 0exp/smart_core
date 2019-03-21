# frozen_string_literal: true

# @api private
# @since 0.5.0
module SmartCore::Initializer::InstanceAttributeAccessing
  # @return [Hash<Symbol,Any>]
  #
  # @api public
  # @since 0.5.0
  def params
    __collect_params__
  end

  # @return [Hash<Symbol,Any>]
  #
  # @api public
  # @since 0.5.0
  def options
    __collect_options__
  end

  # @return [Hash<Symbol,Any>]
  #
  # @api public
  # @since 0.5.0
  def attributes
    __collect_params__.merge(__collect_options__)
  end

  # @return [Hash<Symbol,Any>]
  #
  # @api private
  # @since 0.5.0
  def __collect_params__
    self.class.__params__.each_with_object({}) do |param, memo|
      memo[param.name] = instance_variable_get("@#{param.name}")
    end
  end

  # @return [Hash<Symbol,Any>]
  #
  # @api private
  # @since 0.5.0
  def __collect_options__
    self.class.__options__.each_with_object({}) do |option, memo|
      memo[option.name] = instance_variable_get("@#{option.name}")
    end
  end
end
