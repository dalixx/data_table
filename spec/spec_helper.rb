require 'rubygems'
require 'spec'

require File.join(File.dirname(__FILE__), 'boot') unless defined?(ActiveRecord)

require 'data_table'
include DataTable

require File.join(File.dirname(__FILE__), 'test_controller')

# Wrap tests that use Mocha and skip if unavailable.
def uses_mocha(test_name)
  require 'mocha' unless Object.const_defined?(:Mocha)
rescue LoadError => load_error
  $stderr.puts "Skipping #{test_name} tests. `gem install mocha` and try again."
else
  yield
end