require 'rake'

Gem::Specification.new do |logstash|
  logstash.name = 'chef_logstash'
  logstash.version = '0.1.0'
  logstash.summary = 'Resource Providers to manage Logstash'
  logstash.description = ''
  logstash.authors = ['Miah Johnson']
  logstash.email = 'miah@chia-pet.org'
  logstash.files = 'lib/chef_logstash.rb'
  logstash.homepage = 'https://github.com/miah/chef_logstash'
  logstash.license = 'Apache-2.0'
  logstash.require_path = '.'
end
