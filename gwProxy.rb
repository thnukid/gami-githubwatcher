#bundler
require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'json'
require 'logger'


get '/' do
   'You reached the end of the internet, please return.'
end

post '/payload' do
    push = JSON.parse(request.body.read)
    puts "I got some JSON: #{push.inspect}"
end
