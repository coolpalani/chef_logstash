
require 'chef/resource'
require 'chef/mixin/securable'
require 'chef/resource_collection'

class Chef
  class Resource
    class LogstashInstance < Chef::Resource

      attr_accessor :configs

      state_attrs :enabled, :running, :configured,
        :user, :group, :conf_dir, :dest_dir, :install_type,
        :service_type

      def initialize(name, run_context = nil)
        super
        @resource_name = :logstash_instance
        @provider = Chef::Provider::LogstashInstance
        @action = :create
        @allowed_actions = [:create, :destroy, :enable, :update, :nothing]
        @configs = Chef::ResourceCollection.new
      end

      def user(arg = nil)
        set_or_return(:user, arg, kind_of: String, default: 'logstash')
      end

      def group(arg = nil)
        set_or_return(:group, arg, kind_of: String, default: 'logstash')
      end

      def conf_dir(arg = nil)
        set_or_return(:conf_dir,
                      arg,
                      kind_of: String,
                      default: '/opt/logstash/instance/conf')
      end

      def dst_dir(arg = nil)
        set_or_return(:dst_dir,
                      arg,
                      kind_of: String,
                      default: '/opt/logstash/instance')
      end

      def install_options(arg = nil)
        set_or_return(:install_options, arg, kind_of: Hash)
      end

      def install_type(arg = nil)
        set_or_return(:install_type,
                      arg,
                      kind_of: String,
                      required: true,
                      equal_to: %w(jar debian rhel))
      end

      def service_options(arg = nil)
        set_or_return(:service_options, arg, kind_of: Hash)
      end

      def service_type(arg = nil)
        set_or_return(:service_type,
                      arg,
                      kind_of: String,
                      required: true,
                      equal_to: %w(init runit))
      end

    end
  end
end
