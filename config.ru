require 'sinatra'
require './gwProxy'

set :environment, :production
#set :app_file, 'gwProxy.rb'
disable :run

run Sinatra::Application
