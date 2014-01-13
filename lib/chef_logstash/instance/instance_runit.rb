require 'chef/resource/service'
require_relative '../helpers'

module ChefLogstash
  module Instance
    class Runit
      include ChefLogstash::Helpers

      def initialize(new_resource, run_context = nil)
        @new_resource = new_resource
        @run_context = run_context
        @run_context.include_recipe('runit')
        @install_options = @new_resource.install_options
        @runit = set_runit_res
      end

      def create
        create_service_script
      end

      def enable
        enable_service
      end

      def disable
        disable_service
      end

      private

      def set_runit_res
        Chef::Resource::RunitService.new(
            logstash_service(@new_resource.name), @run_context)
      end

      def create_service_script
        jar_path = logstash_jar_with_path(@new_resource.dst_dir, version)

        r.cookbook          'logstash'
        r.run_template_name 'logstash'
        r.log_template_name 'logstash'
        r.options(
            conf_dir: @new_resource.conf_dir,
            jar_path: jar_path,
            name:     @new_resource.name,
            nofiles:  @new_resource.service_options,
            user:     @new_resource.user,
          )
        r.run_action(:enable)
      end

      def enable_service
        ls_dir = logstash_conf_dir(@new_resource.conf_dir, @new_resource.name)
        ls_svc = logstash_service(@new_resource.name)

        if ::File.directory?(ls_dir)
          if logstash_has_configs?(ls_dir)
            s = Chef::Resource::Service.new(ls_svc, @run_context)
            s.run_action([:enable, :start])
          else
            Chef::Log.info("#{ ls_dir } has no configs. Not enabling #{ ls_svc }.")
          end
        else
          Chef::Log.info("#{ ls_dir } does not exist. Not enabling #{ ls_svc }.")
        end
      end

      def disable_service
        s = Chef::Resource::Service.new(
            logstash_service(@new_resource.name), @run_context)
        s.run_action([:disable, :stop])
      end

      def version
        @install_options.fetch(:version) { :version_not_set }
      end
    end
  end
end
