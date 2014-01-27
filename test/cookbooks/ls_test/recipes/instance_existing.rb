logstash_instance 'test' do
  install_type :existing
  install_options(
    url: node.logstash.install_options.url,
    checksum: node.logstash.install_options.checksum,
    version: node.logstash.install_options.version
  )
  service_type 'init'
end