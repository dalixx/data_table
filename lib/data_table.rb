require 'active_support'
include ActiveSupport::CoreExtensions::String::Inflections 

# THIS DRIVES ME CRAZY
require 'data_table/filter_element'
require 'data_table/filter_selection'
require 'data_table/filter'

ActionController::Base.send :include, DataTable


