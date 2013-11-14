require 'rake'
require 'rake/testtask'
require 'reek/rake/task'
require 'rubocop/rake_task'

task :default => 'test:quick'

namespace :test do

  Rubocop::RakeTask.new

  Rake::TestTask.new do |t|
    t.name = :minitest
    t.libs = %w(lib lib/chef_logstash lib/chef_logstash/instance)
    t.test_files = Dir.glob('test/spec/**/*_spec.rb')
  end

  Reek::Rake::Task.new do |t|
    t.fail_on_error = false
    t.source_files = 'lib/**/*.rb'
  end

  desc 'Run all of the quick tests.'
  task :quick do
    Rake::Task['test:tailor'].invoke
    Rake::Task['test:reek'].invoke
    Rake::Task['test:minitest'].invoke
  end

  desc 'Run _all_ the tests. Go get a coffee.'
  task :complete do
    Rake::Task['test:tailor'].invoke
    Rake::Task['test:reek'].invoke
    Rake::Task['test:minitest'].invoke
    Rake::Task['test:kitchen:all'].invoke
  end

end

namespace :generate_resources do

  task :get_logstash, [:version] do |t, args|
    args.with_defaults(:version => '1.1.13')

    url = "https://github.com/logstash/logstash/archive/v#{ args[:version] }.tar.gz"
    dst_dir = './helpers/chef_generator/logstash'
    tgz     = './helpers/chef_generator/logstash.tar.gz'
    sh "mkdir #{ dst_dir }"
    sh "curl -s -L -o #{ tgz } #{ url }"
    sh "tar xf #{ tgz } --strip-components 1 -C #{ dst_dir }"
  end

  desc 'Generate the plugin resources.'
  task :generate, [:version] => [:get_logstash] do |t, args|
    args.with_defaults(:version => '1.1.13')
  end

  desc 'Clean up downloaded sources.'
  task :cleanup do
    tgz     = './helpers/chef_generator/logstash.tar.gz'
    dst_dir = './helpers/chef_generator/logstash'

    sh "rm -f #{ tgz }"
    sh "rm -rf #{ dst_dir }"
  end

end

namespace :release do

  task :update_metadata do
  end

  task :tag_release do
  end

end
