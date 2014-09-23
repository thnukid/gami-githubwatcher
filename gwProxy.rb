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

<<<<<<< HEAD
  @gitEvent =  request.env['HTTP_X_GITHUB_EVENT']

  if (@gitEvent == "push")
    gParse = Gami::GithubEventParser.new(gami,"git:push", @payload)
  else
    gParse = Gami::GithubEventParser.new(gami,"git:" + @gitEvent.to_s , @payload)
  end
    gParse.save unless gParse.nil?
=======
  case request.env['HTTP_X_GITHUB_EVENT']
    when "push"
      gParse = Gami::GithubEventParser.new(gami,"git:push", @payload)
      gParse.save
      #gami.send_event(gamiEvent, gamiMail, gamiData.to_json)
    end
>>>>>>> parent of 4f7091e... minor clean up
end
