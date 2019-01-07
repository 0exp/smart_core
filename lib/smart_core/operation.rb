# frozen_string_literal: true

# @api public
# @since 0.2.0
class SmartCore::Operation
  require_relative 'operation/exceptions'
  require_relative 'operation/attribute'
  require_relative 'operation/attribute_set'
  require_relative 'operation/attribute_dsl'
  require_relative 'operation/calllable'
  require_relative 'operation/result'
  require_relative 'operation/success'
  require_relative 'operation/failure'
  require_relative 'operation/result_interface_mixin'

  # @since 0.2.0
  extend AttributeDSL
  # @since 0.2.0
  extend Callable
  # @since 0.2.0
  include ResultInterfaceMixin

  # @api public
  # @since 0.2.0
  def call; end

  # TODO: надо сделать обертку вокруг call-метода, чтобы call мог принимать proc, в который
  # сидится result как maybe монада, на которой есть success и failure :)
end
