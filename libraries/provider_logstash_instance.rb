require 'chef/provider'
require File.expand_path('../helpers', __FILE__)

dir = File.dirname(File.absolute_path(__FILE__))
::Dir.glob(dir + 'instance_*') { |f| require f }

class Chef
  class Provider
    class LogstashInstance < Chef::Provider

      def initialize(new_resource, run_context=nil)
        @new_resource = new_resource
        @run_context = run_context
        super
      end

      def whyrun_supported?
        false
      end

      def load_current_resource
      end

      def action_create
        create_dst_dir
        create_group
        create_user
        instance(@new_resource.install_type, 'install')
        instance(@new_resource.service_type, 'create')
        @new_resource.updated_by_last_action(true)
      end

      def action_update
        instance(@new_resource.service_type, 'update')
      end

      def action_destroy
        instance(@new_resource.install_type, 'disable')
        instance(@new_resource.service_type, 'uninstall')
        @new_resource.updated_by_last_action(true)
      end

      def action_enable
        instance(@new_resource.service_type, 'enable')
        @new_resource.updated_by_last_action(true)
      end

      private

      def create_group
        g = Chef::Resource::Group.new(@new_resource.group, @run_context)
        g.run_action(:create)
      end

      def create_user
        u = Chef::Resource::User.new(@new_resource.user, @run_context)
        u.home @new_resource.dst_dir
        u.system true
        u.gid @new_resource.group
        u.run_action(:create)
      end

      def create_dst_dir
        dst_dir = Chef::Resource::Directory.new(@new_resource.dst_dir, @run_context)
        dst_dir.path      @new_resource.dst_dir
        dst_dir.owner     'root'
        dst_dir.group     'root'
        dst_dir.mode      00755
        dst_dir.recursive true
        dst_dir.run_action(:create)
      end

      def instance(type, action)
        instance_class = instance_sub_class(type)
        i = instance_class.new(@new_resource, @run_context)
        i.send(action)
      end

      def instance_sub_class(type)
        klass = "Logstash::Instance::#{ type.capitalize }"
        klass.split('::').reduce(Object) {|kls, t| kls.const_get(t) }
      end

    end
  end
end
