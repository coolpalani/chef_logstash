require_relative '../helpers'

class Logstash
  class Instance
    # TODO: Write class documentation
    class Existing
      include ChefLogstash::Helpers

      def initialize(new_resource, run_context=nil)
        @new_resource = new_resource
        @run_context = run_context
        @install_options = new_resource.install_options
      end

      # We don't really install since its already existing.
      def install
        fetch_logstash_jar unless jar_was_modified_since?
      end

      # We don't really uninstall since its already existing.
      def uninstall
        remove_logstash_jar
      end

      private

      def jar_path
        logstash_jar_with_path(@new_resource.dst_dir, @version)
      end
    end
  end
end
