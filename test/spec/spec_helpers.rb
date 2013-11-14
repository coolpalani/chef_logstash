require 'coveralls'
Coveralls.wear!

require 'chef/event_dispatch/dispatcher'
require 'chef/platform'
require 'chef/run_context'
require 'chef/resource'
require 'chef/resource/service'
require 'chef/provider'
require 'minitest/autorun'
require 'minitest/pride'

project_root = File.dirname( File.absolute_path( __FILE__ ))
libraries_dir = File.join( '', project_root, '/../../libraries/' )
Dir.glob( libraries_dir + '*.rb' ) { |file| require file }
