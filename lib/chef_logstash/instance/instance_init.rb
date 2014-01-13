require 'chef/resource/service'
require 'chef/resource/template'
require_relative '../helpers'

module ChefLogstash
  module Instance
    # TODO: Write class documentation
    class Init
      include ChefLogstash::Helpers

      attr_accessor :conf_files, :configs

      def initialize(new_resource, run_context = nil)
        @new_resource = new_resource
        @run_context = run_context
        @conf_files = ''
        @configs = new_resource.configs
      end

      def create
        create_service_script
      end

      def enable
        enable_service
      end

      def update
        create_service_script
      end

      def disable
        disable_service
      end

      private

      def jar_path
        logstash_jar_with_path(@new_resource.dst_dir, version)
      end

      def ls_svc
        logstash_service(@new_resource.name)
      end

      def conf_dir
        @conf_dir ||= @new_resource.conf_dir
      end

      def create_service_script
        r = Chef::Resource::Template.new(
            logstash_service(@new_resource.name), @run_context)
        r.cookbook 'logstash'
        r.source   'logstash-init.erb'
        r.path     ::File.join('', '/etc/init.d', ls_svc)
        r.mode     00755
        r.owner    'root'
        r.group    'root'
        r.variables(
            conf_dir:        conf_dir,
            jar_path:        jar_path,
            name:            @new_resource.name,
            service_options: @new_resource.service_options,
            user:            @new_resource.user,
          )
        r.run_action(:create)
      end

      def enable_service
        if ::File.directory?(conf_dir)
          if logstash_has_configs?(conf_dir)
            s = Chef::Resource::Service.new(ls_svc, @run_context)
            s.run_action(:enable)
            s.run_action(:start)
          else
            Chef::Log.info(
                "#{ conf_dir } has no configs. Not enabling #{ ls_svc }.")
          end
        else
          Chef::Log.info(
              "#{ conf_dir } does not exist. Not enabling #{ ls_svc }.")
        end
      end

      def disable_service
        s = Chef::Resource::Service.new(ls_svc, @run_context)
        s.run_action(:disable)
        s.run_action(:stop)
      end

      def version
        @new_resource.install_options.fetch(:version) { :version_not_set }
      end
    end
  end
end
