
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'spec_helpers'

describe 'ResourceLogstashConfig', 'Tests for Chef::Resource::LogstashConfig' do

  let(:node) do
    node = Chef::Node.new
    node.automatic['platform'] = 'ubuntu'
    node.automatic['platform_version'] = '12.04'
    node
  end
  let(:events) { Chef::EventDispatch::Dispatcher.new }
  let(:run_context) { Chef::RunContext.new(node, {}, events) }
  let(:instance_name) { 'test_instance' }

  before :each do
    @logstashconfig = Chef::Resource::LogstashConfig.new(instance_name, run_context)
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

    it "has a 'plugin_config' parameter that can be set" do

      test_config = {
        'format' => 'plain',
        'path' => %w(/var/log/httpd/*_log),
        'type' => 'httpd'
      }

      @logstashconfig.plugin_config(test_config)
      assert(@logstashconfig.plugin_config, 'input')
    end

  end

  describe 'Can spawn sub-resources' do

    it "Creates a LogstashConfig::Input::File resource" do
      @logstashconfig.instance('instance_name')
      @logstashconfig.plugin('File')
      @logstashconfig.plugin_type('Input')

      assert_kind_of(Chef::Resource, @logstashconfig)
      assert_respond_to(@logstashconfig, :plugin_config)

      @logstashconfig.plugin_config({ 'debug' => true })

    end
  end

end
