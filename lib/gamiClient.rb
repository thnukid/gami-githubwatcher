require 'faraday'
require 'json'
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

    def test
      output = connection.get 'https://api.github.com/users/thnukid'
      json = output.body
      puts JSON.parse(json)

      r = Response.new JSON.parse(json)

      puts r.id
      puts r.events_url
    end

    def send_event(action,email,rawData = '')
      connection.post do |req|
        req.url @api_url
        req.headers['Content-Type'] = 'application/json'
        req.body = { :event => {:name => action, :email => email, :data => rawData}}.to_json
        puts req.body
      end
    end
  end

end


#gami = Gami::Client.new()
#gami.test
#gami.send_event("gami:test","h.musterman@githo.st","I am the gami client, ye")
#gami.send_event("gami:test","works@gami.nl","I am the gami client, ye")
