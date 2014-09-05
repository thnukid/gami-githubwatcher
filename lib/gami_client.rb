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

    def send_event(action,email,rawData = '')
      connection.post do |req|
        req.url @api_url
        req.headers['Content-Type'] = 'application/json'
        req.body = { :event => {:name => action, :email => email, :data => rawData}}.to_json
        puts req.body
      end
    end
  end

  class GithubEventParser

    def initialize(client, event, rawData)
      @client = client
      @data = JSON.parse(rawData)

      @raw = rawData
      @event = event

      @res = Hash.new
      @res[:game] = Hash.new
      @res[:raw] = rawData
    end

    def save
      @client.send_event(@event, author, dataset)
    end

    def dataset
      {
       :game => compile_game_dataset,
       :raw => @raw
      }
    end

    private
    def compile_game_dataset
      {
        :commits_count => commits_count,
        :commit_stats => commit_stats,
        :repo => repository,
        :message => message
      }
    end

    def author
      @data['head_commit']['author']['email']
    end

    def commits_count
      @data['commits'].length
    end

    def repository
      @data['repository']['full_name']
    end

    def message
      @data['head_commit']['message']
    end

    def commit_stats
      stat = Hash.new
      stat = {:rm_total => 0, :add_total => 0, :mod_total => 0}

      @data['commits'].each do |c|
        stat[:rm_total]  += c['removed'].length
        stat[:add_total] += c['added'].length
        stat[:mod_total] += c['modified'].length
      end
      stat
    end

  end
end

