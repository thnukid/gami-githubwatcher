require 'sinatra'
require 'gwProxy'

set :environment, :production
set :app_file, 'gwProxy.rb'
disable :run

require File.join(File.dirname(__FILE__), 'app_name')
run Sinatra::Application
