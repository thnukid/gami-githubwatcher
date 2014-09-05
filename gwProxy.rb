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

  case request.env['HTTP_X_GITHUB_EVENT']
    when "push"
      gParse = Gami::GithubEventParser.new(gami,"git:push", @payload)
      gParse.save
      #gami.send_event(gamiEvent, gamiMail, gamiData.to_json)
    end
end
