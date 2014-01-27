require './lib/chef_logstash.rb'

LIB_NAME = 'chef_logstash'

Gem::Specification.new do |logstash|
  logstash.name = LIB_NAME
  logstash.version = ChefLogstash::VERSION
  logstash.summary = 'Resource Providers to manage Logstash'
  logstash.description = 'Chef Resource Providers to manage Logstash'
  logstash.authors = ['Miah Johnson']
  logstash.email = 'miah@chia-pet.org'
  logstash.files = 'lib/chef_logstash.rb'
  logstash.homepage = 'https://github.com/miah/chef_logstash'
  logstash.license = 'Apache-2.0'
  logstash.require_paths = ['lib', "lib/#{ LIB_NAME }", "lib/#{ LIB_NAME }/instance"]
  logstash.add_runtime_dependency 'chef', '>= 10.30'
  logstash.add_runtime_dependency 'logstash-lib', '>= 1.3.2'
end
