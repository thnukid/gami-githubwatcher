#bundler
require 'rubygems'
require 'bundler/setup'

require './lib/gami_client'
require 'sinatra'
require 'json'

get '/' do
   'You reached the end of the internet, please return.'
end

post '/github' do
  @payload = request.body.read
  gami = Gami::Client.new()

  @gitEvent =  request.env['HTTP_X_GITHUB_EVENT']

  if (@gitEvent == "push")
    gParse = Gami::GithubEventParser.new(gami,"git:push", @payload)
  else
    gParse = Gami::GithubEventParser.new(gami,"git:" + @gitEvent.to_s , @payload)
  end
    gParse.save unless gParse.nil?
end
