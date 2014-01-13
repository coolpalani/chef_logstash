package 'openjdk-7-jre-headless'

%w(default).each do |instance_name|

  instance_dir = ::File.join('', 'opt', 'logstash', instance_name)

  logstash_instance instance_name do
    dst_dir instance_dir
    conf_dir ::File.join('', instance_dir, 'conf')
    install_type 'jar'
    install_options(
      url: node.logstash.install_options.url,
      checksum: node.logstash.install_options.checksum,
      version: node.logstash.install_options.version
    )
    service_type 'init'
    action [:create]
  end

  logstash_config 'log_files' do
    instance    instance_name
    plugin      'file'
    plugin_type 'input'
    plugin_config(
      path: ['/var/log/*.log'],
      type: 'httpd'
    )
    action [:create, :update]
  end

  logstash_config 'test_output' do
    instance    instance_name
    plugin      'file'
    plugin_type 'output'
    plugin_config(
      path: '/var/log/logstash_test_log',
      flush_interval: 0
    )
    action [:create, :update, :enable]
  end

end
