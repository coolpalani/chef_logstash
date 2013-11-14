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
  task :all do
    Rake::Task['test:minitest'].invoke
    Rake::Task['test:reek'].invoke
    Rake::Task['test:rubocop'].invoke
  end

end

namespace :release do

  task :update_metadata do
  end

  task :tag_release do
  end

end
