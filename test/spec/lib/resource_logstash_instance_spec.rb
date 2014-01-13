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

  describe 'Parameter tests for Chef::Resource::LogstashConfig' do
    it '#user can be set and return a String.' do
      assert_respond_to(@logstash_instance, :user)
      @logstash_instance.user('logstash_user')
      assert(@logstash_instance.user, 'logstash_user')
    end

    it '#group can be set and return a String.' do
      assert_respond_to(@logstash_instance, :group)
      @logstash_instance.group('logstash_group')
      assert(@logstash_instance.group, 'logstash_group')
    end

    it '#conf_dir can be set and return a String.' do
      assert_respond_to(@logstash_instance, :conf_dir)
      @logstash_instance.conf_dir('/opt/logstash')
      assert(@logstash_instance.conf_dir, '/opt/logstash')
    end

    it '#dst_dir can be set and return a String.' do
      assert_respond_to(@logstash_instance, :conf_dir)
      @logstash_instance.dst_dir('/opt/logstash')
      assert(@logstash_instance.dst_dir, '/opt/logstash')
    end

    describe '#install_type' do
      it 'allows setting jar' do
        @logstash_instance.install_type(:jar)
        assert(@logstash_instance.install_type, :jar)
      end

      it 'allows setting debian' do
        @logstash_instance.install_type(:debian)
        assert(@logstash_instance.install_type, :debian)
      end

      it 'allows setting rhel' do
        @logstash_instance.install_type(:rhel)
        assert(@logstash_instance.install_type, :rhel)
      end

      it 'does not allow other types of objects.' do
        assert_raises(Chef::Exceptions::ValidationFailed) do
          @logstash_instance.install_type(%w(foo bar baz))
        end

        assert_raises(Chef::Exceptions::ValidationFailed) do
          @logstash_instance.install_type('foobarbaz')
        end
      end
    end

    describe '#install_options parameter' do
      it 'allows hash like objects' do
        test_config = {
          format: 'plain',
          path: %w(/var/log/httpd/*_log),
          type: 'httpd'
        }
        @logstash_instance.install_options(test_config)
        assert(@logstash_instance.install_options, 'input')
      end

      it 'does not allow other types of objects.' do
        assert_raises(Chef::Exceptions::ValidationFailed) do
          @logstash_instance.install_options(%w(foo bar baz))
        end

        assert_raises(Chef::Exceptions::ValidationFailed) do
          @logstash_instance.install_options('foobarbaz')
        end
      end
    end

    describe '#service_type' do
      it 'allows setting init' do
        @logstash_instance.service_type(:init)
        assert(@logstash_instance.service_type, :init)
      end

      it 'allows setting runit' do
        @logstash_instance.service_type(:runit)
        assert(@logstash_instance.service_type, :runit)
      end

      it 'does not allow other types of objects.' do
        assert_raises(Chef::Exceptions::ValidationFailed) do
          @logstash_instance.service_type(%w(foo bar baz))
        end

        assert_raises(Chef::Exceptions::ValidationFailed) do
          @logstash_instance.service_type('foobarbaz')
        end
      end
    end

    describe '#service_options parameter' do
      it 'allows hash like objects' do
        test_config = {
          format: 'plain',
          path: %w(/var/log/httpd/*_log),
          type: 'httpd'
        }
        @logstash_instance.service_options(test_config)
        assert(@logstash_instance.service_options, 'input')
      end

      it 'does not allow other types of objects.' do
        assert_raises(Chef::Exceptions::ValidationFailed) do
          @logstash_instance.service_options(%w(foo bar baz))
        end

        assert_raises(Chef::Exceptions::ValidationFailed) do
          @logstash_instance.service_options('foobarbaz')
        end
      end
    end
  end
end
