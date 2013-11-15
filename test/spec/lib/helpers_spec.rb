require_relative '../spec_helpers'
require 'chef_logstash/helpers'

describe 'ChefLogstashHelpers', 'Tests for ChefLogstash::Helpers' do

  include ChefLogstash::Helpers

  describe 'String manipulation methodsgt' do
    it 'Returns the name of the logstash_service' do
      assert_equal('logstash_test', logstash_service('test'))
    end
  end

  describe 'Resource lookup methods' do
  end
end
