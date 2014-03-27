require 'chef/resource'
require 'chef/mixin/securable'

class Chef
  class Resource
    class LogstashConfig < Chef::Resource

      include Chef::Mixin::Securable

      attr_accessor :conf_file

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

      def codec(arg = nil)
        set_or_return(:plugin_type,
                      arg,
                      kind_of: [String],
                      equal_to: available_codecs
        )
      end

      private

      def available_codecs
        %w(
          base
          dots
          edn
          edn_lines
          fluent graphite
          json
          json_lines
          json_spooler
          line msgpack
          multiline
          netflow
          noop
          oldlogstashjson
          plain
          rubydebug
          spool
        )
      end
    end
  end
end
