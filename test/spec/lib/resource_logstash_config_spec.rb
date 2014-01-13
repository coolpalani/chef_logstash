
require_relative '../spec_helpers'
require 'resource_logstash_config'
require 'provider_logstash_config'

describe 'ResourceLogstashConfig',
         'Tests for Chef::Resource::LogstashConfig' do

  let(:node) do
    node = Chef::Node.new
    node.automatic['platform'] = 'ubuntu'
    node.automatic['platform_version'] = '12.04'
    node
  end
  let(:events) { Chef::EventDispatch::Dispatcher.new }
  let(:run_context) { Chef::RunContext.new(node, {}, events) }
  let(:instance_name) { 'test_instance' }
  let(:logstash_config) do
    Chef::Resource::LogstashConfig.new(instance_name, run_context)
  end

  before :each do
    @logstashconfig = logstash_config
  end

  describe 'Chef Resource Checks for Chef::Resource::LogstashConfig' do
    it 'Is a Chef::Resource?' do
      assert_kind_of(Chef::Resource, @logstashconfig)
    end

    it 'Is a instance of LogstashConfig' do
      assert_instance_of(Chef::Resource::LogstashConfig, @logstashconfig)
    end
  end

  describe 'Parameter tests for Chef::Resource::LogstashConfig' do
    it "has a 'instance' parameter that can be set" do
      assert_respond_to(@logstashconfig, :instance)
      @logstashconfig.instance('instance_name')
      assert(@logstashconfig.instance, 'instance_name')
    end

    it "has a 'plugin' parameter that can be set" do
      assert_respond_to(@logstashconfig, :plugin)
      @logstashconfig.plugin('file')
      assert(@logstashconfig.plugin, 'file')
    end

    it "has a 'plugin_type' parameter that can be set" do
      assert_respond_to(@logstashconfig, :plugin_type)
      @logstashconfig.plugin_type('input')
      assert(@logstashconfig.plugin_type, 'input')
    end

    describe "'plugin_config' parameter" do
      it 'allows hash like objects' do
        test_config = {
          'format' => 'plain',
          'path' => %w(/var/log/httpd/*_log),
          'type' => 'httpd'
        }
        @logstashconfig.plugin_config(test_config)
        assert(@logstashconfig.plugin_config, 'input')
      end

      it 'doesnt allow other types of objects.' do
        assert_raises(Chef::Exceptions::ValidationFailed) do
          @logstashconfig.plugin_config(%w(foo bar baz))
        end

        assert_raises(Chef::Exceptions::ValidationFailed) do
          @logstashconfig.plugin_config('foobarbaz')
        end
      end
    end
  end
end
