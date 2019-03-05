# frozen_string_literal: true

# @api public
# @since 0.5.0
class SmartCore::Container
  require_relative 'container/exceptions'
  require_relative 'container/commands'
  require_relative 'container/command_set'
  require_relative 'container/compatability'
  require_relative 'container/dependency'
  require_relative 'container/registry'
  require_relative 'container/resolver'
end
