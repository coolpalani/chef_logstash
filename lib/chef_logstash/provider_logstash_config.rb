require 'chef/provider'
require 'chef_logstash/helpers'

# Chef
class Chef
  # Chef Provider
  class Provider
    # Provides actions for the LogstashConfig resource.
    class LogstashConfig < Chef::Provider

      include ChefLogstash::Helpers

      def initialize(new_resource, run_context = nil)
        @new_resource = new_resource
        @run_context = run_context

        @conf_dir = conf_dir
        @conf_file = conf_file
        @instance = instance
        @plugin_class = plugin_class
        @plugin_object = plugin_object
        super
      end

      def whyrun_supported?
        false
      end

      def load_current_resource
      end

      def action_create
        create_conf_dir
        configure_plugin(@new_resource.plugin_config)
        create_conf_file
        update_instance_resource_collection
        @new_resource.updated_by_last_action(true)
      end

      def action_destroy
        destroy_conf_file
        destroy_conf_dir
        @new_resource.updated_by_last_action(true)
      end

      def action_enable
        instance.run_action(:enable)
      end

      def action_update
        instance.run_action(:update)
      end

      private

      def conf_file
        @new_resource.conf_file ||= logstash_config_file(conf_dir, @new_resource.name)
      end

      def conf_dir
        @conf_dir ||= instance.conf_dir
      end

      def instance
        @instance ||= lookup_instance(@new_resource.instance, @run_context)
      end

      def update_instance_resource_collection
        @instance.configs << @new_resource
      end

      def plugin_object
        @plugin_object ||= plugin_class.new(@new_resource.name, @run_context)
      end

      def plugin_class
        @plugin_class ||= lookup_plugin_class
      end

      def plugin_type
        @plugin_type ||= @new_resource.plugin_type
      end

      def plugin
        @plugin ||= @new_resource.plugin
      end

      def lookup_plugin_class
        plug = plugin.capitalize
        type = plugin_type.capitalize
        klass = "Chef::Resource::Logstash#{ type }#{ plug }"
        klass.split('::').reduce(Object) { |kls, t| kls.const_get(t) }
      end

      def render_conf_file(plugin_config)
        file = Logstash::ConfigGenerate.new
        file.plugin_config(plugin_config)
        file.plugin_type = plugin_type
        file.plugin = plugin
        file.render
        file.config
      end

      def rendered_conf
        @rendered_conf ||= render_conf_file(@new_resource.plugin_config)
      end

      # Instantiate plugin subclass
      # @param arg
      def configure_plugin(arg)
        # Iterate over the hash of resource arguments.
        arg.each do |k, v|
          plugin_object.send(k, v)
        end
      rescue RuntimeError => e
        puts "There was an issue: #{ e }"
      end

      def create_conf_dir
        dir = Chef::Resource::Directory.new(conf_dir, @run_context)
        dir.owner 'root'
        dir.group 'root'
        dir.mode 00755
        dir.run_action(:create)
      end

      def create_conf_file
        file = Chef::Resource::File.new(conf_file, @run_context)
        file.owner 'root'
        file.group 'root'
        file.mode 00644
        file.content rendered_conf
        file.run_action(:create)
      end

      def destroy_conf_file
        file = Chef::Resource::File.new(conf_file, @run_context)
        file.run_action(:destroy)
      end

      def destroy_conf_dir
        dir = Chef::Resource::Directory.new(conf_dir, @run_context)
        dir.run_action(:delete)
      end

      # FIXME
      # Looks for config files in the config directory that are not owned
      # by any logstash_config resources.
      # @param name type [String] The unique name of that resource.
      def logstash_clean_configs(name)
        i = logstash_has_configs?(conf_dir)
        i.each do |config|
          unless lookup_resource(:logstash_config, i)
            logstash_delete_old_config(::File.join('', conf_dir, i))
          end
        end
      end

    end
  end
end

# Logstash
class Logstash
  # A hopefully valid logstash configuration generator.
  class ConfigGenerate

    attr_accessor :config, :plugin_type, :plugin

    def initialize
      @config = ''
    end

    def plugin_config(config = {})
      @plugin_config ||= config
    end

    def render
      @config << cfg_start
      @config << cfg_name
      plugin_config.each do |option, setting|
        @config << cfg_type(option, setting)
      end
      @config << cfg_end
      @config << cfg_end
    end

    private

    def cfg_type(option, setting)
      type = setting.class.to_s
      case type
      when 'String'
        cfg_string(option, setting)
      when 'Array' || 'Hash'
        cfg_array(option, setting)
      when 'Fixnum' || 'TrueClass' || 'FalseClass'
        cfg_number(option, setting)
      else
        Chef::Log.info("cfg_type was unable to lookup sc: #{ type } o: #{ option } s: #{ setting }")
      end
    end

    def cfg_string(key, value)
      "#{ key } => \"#{ value }\"\n"
    end

    def cfg_array(key, value)
      "#{ key } => #{ value.to_a.flatten }\n"
    end

    def cfg_number(key, value)
      "#{ key } => #{ value }\n"
    end

    def cfg_name
      "#{ plugin } {\n"
    end

    def cfg_start
      "#{ plugin_type } {\n"
    end

    def cfg_end
      '}'
    end

  end
end
