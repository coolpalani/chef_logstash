require File.expand_path('../resource_logstash_config', __FILE__)

class Chef
  class Resource
    class LogstashOutputS3 < Chef::Resource::LogstashConfig
      def access_key_id(arg = nil)
        set_or_return(:access_key_id,
                      arg,
                      kind_of: [String])
      end

      def bucket(arg = nil)
        set_or_return(:bucket,
                      arg,
                      kind_of: [String],
                      required: true)
      end

      def canned_acl(arg = nil)
        set_or_return(:canned_acl,
                      arg,
                      kind_of: [String],
                      equal_to: %w(private
                                   public_read
                                   public_read_write
                                   authenticated_read),
                      default: 'private')
      end

      def endpoint_region(arg = nil)
        set_or_return(:endpoint_region,
                      arg,
                      kind_of: [String],
                      default: 'us-east-1')
      end

      def format(arg = nil)
        set_or_return(:format,
                      arg,
                      kind_of: [String],
                      equal_to: %w(json plain),
                      default: 'plain')
      end

      def secret_access_key(arg = nil)
        set_or_return(:secret_access_key,
                      arg,
                      kind_of: [String])
      end

      def size_file(arg = nil)
        set_or_return(:size_file,
                      arg,
                      kind_of: [Fixnum],
                      default: 0)
      end

      def time_file(arg = nil)
        set_or_return(:time_file,
                      arg,
                      kind_of: [Fixnum],
                      default: 0)
      end

      def use_ssl(arg = nil)
        set_or_return(:use_ssl,
                      arg,
                      kind_of: [TrueClass, FalseClass],
                      default: true)
      end
    end
  end
end
