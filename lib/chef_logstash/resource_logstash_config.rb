
require 'chef/resource'
require 'chef/mixin/securable'

class Chef
  class Resource
    # TODO: Write class documentation
    class LogstashConfig < Chef::Resource
      attr_accessor :conf_file

      state_attrs :enabled, :running, :configured, :config

      def initialize(name, run_context = nil)
        super
        @resource_name = :logstash_config
        @provider = Chef::Provider::LogstashConfig
        @action = :create
        @allowed_actions = [:create, :destroy, :enable, :update, :nothing]

        @plugin = nil
        @plugin_type = nil
        @plugin_config = nil
      end

      def instance(arg = nil)
        set_or_return(:instance, arg, kind_of: [String])
      end

      def plugin(arg = nil)
        set_or_return(:plugin, arg, kind_of: [String])
      end

      def plugin_type(arg = nil)
        set_or_return(:plugin_type, arg, kind_of: [String])
      end

      def plugin_config(arg = nil)
        set_or_return(:plugin_config, arg, kind_of: [Hash])
      end
    end
  end
end
