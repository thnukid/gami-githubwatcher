#bundler
require 'rubygems'
require 'bundler/setup'

require './lib/gamiClient'
require 'sinatra'
require 'json'

get '/' do
   'You reached the end of the internet, please return.'
end

post '/github' do
  @payload = JSON.parse(request.body.read)
  gami = Gami::Client.new()

  case request.env['HTTP_X_GITHUB_EVENT']
    when "push"
      gamiEvent = "git:push"
      gamiMail = @payload['head_commit']['author']['email']

      gamiData = Hash.new
      gamiData[:game] = Hash.new
      gamiData[:game][:commits_count] = @payload['commits'].length
      gamiData[:game][:repo] = @payload['repository']['full_name']
      gamiData[:game][:message] = @payload['head_commit']['message']
      
      #gamiData[:original] = Hash.new
      #gamiData[:original] = @payload

      @payload['commits'].each do |com|
        gamiData[:game][:rm_total]  =  com['removed'].length
        gamiData[:game][:add_total] =  com['added'].length
        gamiData[:game][:mod_total] =  com['modified'].length
      end
    end

    #puts gamiData.to_json
    gami.send_event(gamiEvent, gamiMail, gamiData.to_json)
end
