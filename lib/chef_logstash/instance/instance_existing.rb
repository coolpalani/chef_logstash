require_relative '../helpers'
require 'digest'

module ChefLogstash
  module Instance
    # TODO: Write class documentation
    class Existing
      include ChefLogstash::Helpers

      def initialize(new_resource, run_context = nil)
        @new_resource = new_resource
        @run_context = run_context
        @install_options = new_resource.install_options
        @source = source
        @version = version
        @checksum = checksum
      end

      # We don't really install since its already existing.
      def install
        fetch_logstash_jar
      end

      # We don't really uninstall since its already existing.
      def uninstall
        remove_logstash_jar
      end

      private

      def fetch_logstash_jar
        Chef::Log.debug("About to copy #{ jar_path }")
        FileUtils.cp(@source, jar_path)

        Chef::Log.debug("Chmod'ing #{ jar_path }")
        ::File.chmod(00644, jar_path)

        Chef::Log.debug("Chown'ing #{ jar_path }")
        ::File.chown('root', 'root', jar_path)
      end

      def valid_checksum?
        source_checksum.eql?(checksum)
      end

      def destination_checksum
        Digest::SHA256.file(jar_path).hexdigest
      end

      def source_checksum
        Digest::SHA256.file(@source).hexdigest
      end

      def checksum
        @install_options.fetch(:checksum) { :checksum_not_set }
      end

      def version
        @install_options.fetch(:version) { :version_not_set }
      end

      def source
        @install_options.fetch(:source) { :source_not_set }
      end

      def jar_path
        logstash_jar_with_path(@new_resource.dst_dir, @version)
      end

      def remove_logstash_jar
        f = Chef::Resource::File.new(jar_path, @run_context)
        f.run_action(:delete)
      end
    end
  end
end
