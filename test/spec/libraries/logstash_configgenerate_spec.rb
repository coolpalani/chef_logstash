require 'minitest/autorun'
require 'minitest/pride'

require_relative '../../../libraries/provider_logstash_config'

describe 'Logstash::ConfigGenerate', 'Tests for Logstash::ConfigGenerate' do

  let(:cg) { Logstash::ConfigGenerate.new }

  let(:bool_string_conf) do
    {
      bucket: 'example-logstash',
      format: 'json',
      endpoint_region: 'us-east-1',
      use_ssl: true,
    }
  end

  describe 'plugin_config' do
    it 'accepts a valid configuration' do
      assert cg.plugin_config(bool_string_conf)
    end
  end

  describe 'render' do
    it 'renders a valid configuration.' do
      cg.plugin_config(bool_string_conf)
      assert cg.render
    end
  end
end
