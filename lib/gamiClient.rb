require "faraday"
require 'json'
require 'pry'

module Gami

  class GamiBase
    def connection
      @connection ||= ::Faraday.new(:url => 'http://gami.kabisa.nl') do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  ::Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

  end

  class Client < GamiBase

    def initialize(api_url = nil)
      @api_url = api_url || "api/events"
    end

    #def receive_event(action,email,rawData)
      #output = connection.get @api_url
      #json = output.body
      #puts JSON.parse(json)
    #end

    def send_event(action,email,rawData)
      connection.post do |req|
        req.url @api_url
        req.headers['Content-Type'] = 'application/json'
        #req.body = { :name => action, :email => email, :data => rawData }.to_json
        req.body = { :event => {:name => action, :email => email, :data => rawData}}.to_json
        puts req.body
      end
    end
  end

end


gami = Gami::Client.new()
gami.send_event("gami:test","h.musterman@githo.st","I am the gami client, ye")
gami.send_event("gami:test","works@gami.nl","I am the gami client, ye")
