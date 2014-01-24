source_url = 'https://download.elasticsearch.org' \
             '/logstash/logstash/logstash-1.3.3-flatjar.jar'

logstash_jar = ::File.join(Chef::Config[:file_cache_path],
                           'logstash.jar')

remote_file 'logstash_jar' do
  source source_url
  path   logstash_jar
  owner  'root'
  group  'root'
  mode 00644
end

logstash_instance 'test' do
  install_type :existing
  install_options({
    source: logstash_jar,
    checksum: node.logstash.install_options.checksum,
    version: node.logstash.install_options.version
  })
  service_type 'init'
end