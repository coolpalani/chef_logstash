
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'spec_helpers'

describe 'ProviderLogstashConfig', 'Tests for Chef::Provider::LogstashConfig' do

  let(:node) do
    node = Chef::Node.new
    node.automatic['platform'] = 'ubuntu'
    node.automatic['platform_version'] = '12.04'
    node
  end

  let(:instance_name) { 'test_instance' }

  let(:events) { Chef::EventDispatch::Dispatcher.new }
  let(:run_context) { Chef::RunContext.new(node, {}, events) }
  let(:new_resource) { Chef::Resource::LogstashConfig.new(instance_name) }
  let(:current_resource) { Chef::Resource::LogstashConfig.new(instance_name) }
  let(:provider) { Chef::Provider::LogstashConfig.new(instance_name, run_context) }

  before :each do
    provider.stub(:load_current_resource).and_return(current_resource)
    provider.new_resource = new_resource
    provider.current_resource = current_resource
  end

  describe 'Chef::Provider::LogstashConfig actions' do

    describe 'create' do
      it "has a 'create' action" do
        provider.run_action(:create)
      end
    end

    describe 'enable' do
      before do
        provider.current_resource.running(false)
      end

      it "has a 'enable' action" do
        provider.run_action(:enable)
      end
    end

    describe 'destroy' do
      it "has a 'destroy' action" do
        provider.run_action(:destroy)
      end
    end

  end
end
