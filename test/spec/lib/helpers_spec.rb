require_relative '../spec_helpers'
require 'chef_logstash/helpers'

describe 'ChefLogstashHelpers', 'Tests for ChefLogstash::Helpers' do

  include ChefLogstash::Helpers

  describe 'String manipulation methods' do
    it 'Returns the name of the logstash_service' do
      assert_equal('logstash_foo', logstash_service('foo'))
    end

    it 'Returns the name of a conf_dir' do
      assert_equal('/bar/foo', logstash_conf_dir('bar', 'foo'))
    end

    it 'Returns the name of a config_file' do
      assert_equal('/bar/foo.conf', logstash_config_file('bar', 'foo'))
    end

  end

  describe 'Resource lookup methods' do

    it 'Checks if the instance is configured.' do
      skip
    end

    it 'Can locate a resource in the ResourceCollection.' do
      skip
    end

    it 'Can locate a logstash_instance in the ResourceCollection.' do
      skip
    end

  end
end
