require 'chef/resource'

module ChefLogstash
  # TODO: Write class documentation
  module Helpers
    def logstash_service(name)
      "logstash_#{ name }"
    end

    def logstash_conf_dir(dir, name)
      ::File.join('', dir, name)
    end

    def logstash_config_file(dir, name)
      ::File.join('', dir, "#{ name }.conf")
    end

    # Determines if a specific instance is configured or not.
    # @param type [String] The instance name
    # @return [TrueClass] or [FalseClass] depending on result.
    def logstash_configured?(name)
      true
    end

    # Finds a resource if it exists in the collection.
    # @param type [String] The resources proper name, eg LogstashInstance or LogstashConfig
    # @param name [String] The unique name of that resource.
    # @return [Resource] Hopefully the resource object you were looking for.
    #
    def lookup_resource(type, name, run_context)
      begin
        run_context.resource_collection.find("#{ type }[#{ name }]")
      rescue ArgumentError => e
        puts "You provided invalid arugments to resource_collection.find: #{ e }"
      rescue RuntimeError => e
        puts "The resources you searched for were not found: #{ e }"
      end
    end

    def lookup_instance(name, run_context)
      lookup_resource(:logstash_instance, name, run_context)
    end
  end
end
