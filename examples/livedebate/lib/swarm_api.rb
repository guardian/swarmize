require 'json'
require 'httparty'

class SwarmApi
  include HTTParty
  base_uri 'http://collector.swarmize.com'
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def send(data)
    path = "/swarms/#{token}.json"

    response = self.class.post(path, {body: data.to_json})

    puts "Response #{response.code} #{response.message}:
    #{response.body}"
  end
end

