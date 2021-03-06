# frozen_string_literal: true

require "rom/plugin_registry"
require "rom/global/plugin_dsl"

module ROM
  # Globally accessible public interface exposed via ROM module
  #
  # @api public
  module Global
    # Set base global registries in ROM constant
    #
    # @api private
    def self.extended(rom)
      super

      rom.instance_variable_set("@adapters", {})
      rom.instance_variable_set("@plugin_registry", PluginRegistry.new)
    end

    # An internal adapter identifier => adapter module map used by setup
    #
    # @return [Hash<Symbol=>Module>]
    #
    # @api private
    attr_reader :adapters

    # An internal identifier => plugin map used by the setup
    #
    # @return [Hash]
    #
    # @api private
    attr_reader :plugin_registry

    # Global plugin setup DSL
    #
    # @example
    #   ROM.plugins do
    #     register :publisher, Plugin::Publisher, type: :command
    #   end
    #
    # @api public
    def plugins(*args, &block)
      PluginDSL.new(plugin_registry, *args, &block)
    end

    # Register adapter namespace under a specified identifier
    #
    # @param [Symbol] identifier
    # @param [Class,Module] adapter
    #
    # @return [self]
    #
    # @api private
    def register_adapter(identifier, adapter)
      adapters[identifier] = adapter
      self
    end
  end
end
