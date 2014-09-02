require "faraday"
require 'json'

module Gami

  class Base
    def connection
      @connection ||= ::Faraday.new() do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  ::Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

  end

  class Client < Base
    
    def initialize(api_url = nil)
      #@api_host = api_host || "http://localhost:4567/api/events"
      @api_url = api_url || "https://api.github.com/users/thnukid"
    end

    def send_event(action,email,rawData)
      output = connection.get @api_url
      json = output.body
      puts JSON.parse(json)
    end
  end

end


gami = Gami::Client.new()
gami.send_event("test","test@test.de","")
