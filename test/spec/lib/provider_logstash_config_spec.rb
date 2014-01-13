require_relative '../spec_helpers'
require 'resource_logstash_config'
require 'provider_logstash_config'
require 'resource_logstash_instance'
require 'provider_logstash_instance'

describe 'ProviderLogstashConfig', 'Tests for Chef::Provider::LogstashConfig' do

  let(:node) do
    node = Chef::Node.new
    node.automatic['platform'] = 'ubuntu'
    node.automatic['platform_version'] = '12.04'
    node
  end

  let(:instance_name) { 'test_instance' }

  let(:instance_res) do
    r = Chef::Resource::LogstashInstance.new(instance_name)
    r
  end

  let(:config_res) do
    r =  Chef::Resource::LogstashConfig.new(instance_name)
    r.instance()
    r
  end

  let(:events) { Chef::EventDispatch::Dispatcher.new }

  let(:run_context) do
    r = Chef::RunContext.new(node, {}, events)
    r.resource_collection << config_res
    r.resource_collection << instance_res
    r
  end

  let(:provider) do
    Chef::Provider::LogstashConfig.new(config_res, run_context)
  end

  describe 'Class Ancestory Checks for Chef::Provider::LogstashConfig' do
    it 'Is a Chef::Provider?' do
      assert_kind_of(Chef::Provider, provider)
    end

    it 'Is a instance of LogstashConfig' do
      assert_instance_of(Chef::Provider::LogstashConfig, provider)
    end
  end

  describe 'Action tests for Chef::Provider::LogstashConfig' do

    it "has a 'create' action" do
      assert_respond_to(provider, 'action_create')
    end

    it "has a 'enable' action" do
      assert_respond_to(provider, 'action_enable')
    end

    it "has a 'destroy' action" do
      assert_respond_to(provider, 'action_destroy')
    end
  end

end
