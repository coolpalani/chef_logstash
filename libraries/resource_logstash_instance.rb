
require 'chef/resource'
require 'chef/mixin/securable'

class Chef
  class Resource
    class LogstashInstance < Chef::Resource

      attr_accessor :configs

      def initialize(name, run_context=nil)
        super
        @resource_name = :logstash_instance
        @provider = Chef::Provider::LogstashInstance
        @action = :create
        @allowed_actions = [:create, :destroy, :enable, :update, :nothing]
        @configs = Chef::ResourceCollection.new
      end


      def user(arg=nil)
        set_or_return(:user, arg, :kind_of => String, :default => 'logstash')
      end

      def group(arg=nil)
        set_or_return(:group, arg, :kind_of => String, :default => 'logstash')
      end

      def conf_dir(arg=nil)
        set_or_return(:conf_dir,
                      arg,
                      :kind_of => String,
                      :default => '/opt/logstash/instance/conf')
      end

      def dst_dir(arg=nil)
        set_or_return(:dst_dir,
                      arg,
                      :kind_of => String,
                      :default => '/opt/logstash/instance')
      end

      def version(arg=nil)
        set_or_return(:version, arg, :kind_of => String, :default => '1.1.9')
      end

      def url(arg=nil)
        set_or_return(:url, arg, :kind_of => String, :required => true)
      end

      def checksum(arg=nil)
        set_or_return(:checksum, arg, :kind_of => String, :required => true)
      end

      def install_options(arg=nil)
        set_or_return(:install_options, arg, :kind_of => Hash)
      end

      def install_type(arg=nil)
        set_or_return(:install_type,
                      arg,
                      :kind_of => String,
                      :required => true,
                      :equal_to => %w(jar debian rhel),
                      :default => 'jar')
      end

      def service_options(arg=nil)
        set_or_return(:service_options, arg, :kind_of => Hash)
      end

      def service_type(arg=nil)
        set_or_return(:service_type,
                      arg,
                      :kind_of => String,
                      :required => true,
                      :equal_to => %w(init runit),
                      :default => 'init')
      end

      def nofiles(arg=nil)
        set_or_return(:nofiles, arg, :kind_of => Fixnum, :default => 1024)
      end

    end
  end
end
