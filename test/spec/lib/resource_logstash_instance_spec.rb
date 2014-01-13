require_relative '../spec_helpers'
require 'resource_logstash_instance'
require 'provider_logstash_instance'

describe 'ResourceLogstashInstance',
  'Tests for Chef::Resource::LogstashInstance' do

  let(:node) do
    node = Chef::Node.new
    node.automatic['platform'] = 'ubuntu'
    node.automatic['platform_version'] = '12.04'
    node
  end
  let(:events) { Chef::EventDispatch::Dispatcher.new }
  let(:run_context) { Chef::RunContext.new(node, {}, events) }
  let(:instance_name) { 'test_instance' }
  let(:logstash_instance) do
    Chef::Resource::LogstashInstance.new(instance_name, run_context)
  end

  before :each do
    @logstash_instance = logstash_instance
  end

  describe 'Chef Resource Checks for Chef::Resource::LogstashInstance' do
    it 'Is a Chef::Resource?' do
      assert_kind_of(Chef::Resource, @logstash_instance)
    end

    it 'Is a instance of LogstashInstance' do
      assert_instance_of(Chef::Resource::LogstashInstance, @logstash_instance)
    end
  end
end
