# frozen_string_literal: true

# @api private
# @since 0.5.0
module SmartCore::Container::RegistryBuilder
  class << self
    # @param commands [SmartCore::Container::CommandSet]
    # @return [SmartCore::Container::Registry]
    #
    # @api private
    # @since 0.5.0
    def build(commands)
      SmartCore::Container::Registry.new.tap do |registry|
        commands.each { |command| command.call(registry) }
      end
    end
  end
end
